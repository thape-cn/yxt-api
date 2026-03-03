# frozen_string_literal: true

require 'httpx'
require 'json'
require 'tmpdir'
require 'uri'
require 'yxt-api/job_level'
require 'yxt-api/department'
require 'yxt-api/position'
require 'yxt-api/user'
require 'yxt-api/version'

module Yxt
  class YxtAPI_Error < RuntimeError; end

  class << self
    attr_accessor :apikey
    attr_accessor :secretkey

    attr_accessor :app_id
    attr_accessor :app_secret
    attr_accessor :base_url
    attr_accessor :token_url
    attr_accessor :token_cache_file
  end

  # Make an HTTP request with the given verb to YXT API server
  # @param resource [String]
  # @option options [Hash]
  # @return [HTTPX::Response]
  def self.request(resource, options = {})
    access_token = access_token!
    res = perform_api_request(resource, options, access_token)
    business_code = extract_business_code(res)

    if business_code == 40101
      res = perform_api_request(resource, options, refresh_access_token!)
      business_code = extract_business_code(res)
    end

    raise_for_business_code!(business_code)
    res
  end

  private_class_method

  def self.perform_api_request(resource, options, access_token)
    origin = api_origin
    if @http.nil? || @http_origin != origin
      @http = HTTPX.with(origin: origin)
      @http_origin = origin
    end

    payload = options || {}
    res = @http.post("/#{resource}", headers: { 'Authorization' => access_token }, json: payload)
    attach_response_compatibility!(res)
    res
  end

  def self.attach_response_compatibility!(response)
    response.define_singleton_method(:code) { status } unless response.respond_to?(:code)
    response.define_singleton_method(:parse) { json } unless response.respond_to?(:parse)
  end

  def self.raise_for_business_code!(business_code)
    case business_code
    when 40101
      raise YxtAPI_Error, 'accessToken 无效或已过期！'
    when 50001
      raise YxtAPI_Error, '未授权该API！'
    when 50002
      raise YxtAPI_Error, 'API 功能未授权！'
    when 60100
      raise YxtAPI_Error, '服务内部错误！'
    when 60101
      raise YxtAPI_Error, '业务处理错误！'
    end
  end

  def self.extract_business_code(response)
    payload = response.json
    code = payload['code'] || payload[:code]
    code.is_a?(String) ? code.to_i : code
  rescue StandardError
    nil
  end

  def self.access_token!
    token_mutex.synchronize do
      cached = read_cached_token
      return cached['accessToken'] if token_valid?(cached)

      refresh_access_token_without_lock!
    end
  end

  def self.refresh_access_token!
    token_mutex.synchronize do
      refresh_access_token_without_lock!
    end
  end

  def self.refresh_access_token_without_lock!
    response = token_http.post("/token?#{token_query}")
    attach_response_compatibility!(response)

    unless response.status.to_i.between?(200, 299)
      raise YxtAPI_Error, "获取 accessToken 失败，HTTP #{response.status}"
    end

    payload = response.json
    token, expire_seconds = extract_token_payload(payload)

    if token.to_s.empty? || expire_seconds.to_i <= 0
      details = extract_token_error(payload)
      details = '响应缺少 accessToken 或 expireSeconds' if details.to_s.empty?
      raise YxtAPI_Error, "获取 accessToken 失败，#{details}"
    end

    write_cached_token(
      'accessToken' => token,
      'expireAt' => Time.now.to_i + expire_seconds.to_i
    )
    token
  rescue HTTPX::Error, JSON::ParserError => e
    raise YxtAPI_Error, "获取 accessToken 异常: #{e.message}"
  end

  def self.token_valid?(cached)
    return false unless cached.is_a?(Hash)
    return false if cached['accessToken'].to_s.empty?
    return false if cached['expireAt'].to_i <= 0

    Time.now.to_i < cached['expireAt'].to_i - 60
  end

  def self.read_cached_token
    path = token_cache_path
    return nil unless File.file?(path)

    JSON.parse(File.read(path))
  rescue StandardError
    nil
  end

  def self.write_cached_token(payload)
    path = token_cache_path
    File.write(path, JSON.generate(payload))
    File.chmod(0o600, path)
  end

  def self.token_cache_path
    return token_cache_file unless token_cache_file.to_s.empty?

    app_name = app_id_value.to_s.gsub(/[^a-zA-Z0-9_-]/, '_')
    raise YxtAPI_Error, '请先配置 app_id（或兼容字段 apikey）' if app_name.empty?

    File.join(Dir.tmpdir, "yxt-access-token-#{app_name}.json")
  end

  def self.token_query
    app_id = app_id_value
    app_secret = app_secret_value
    if app_id.to_s.empty? || app_secret.to_s.empty?
      raise YxtAPI_Error, '请先配置 app_id/app_secret（或兼容字段 apikey/secretkey）'
    end

    URI.encode_www_form(appId: app_id, appSecret: app_secret)
  end

  def self.app_id_value
    app_id || apikey
  end

  def self.app_secret_value
    app_secret || secretkey
  end

  def self.api_origin
    base_url || 'https://openapi.yunxuetang.cn'
  end

  def self.token_origin
    token_url || api_origin
  end

  def self.token_http
    if @token_http.nil? || @token_http_origin != token_origin
      @token_http = HTTPX.with(origin: token_origin)
      @token_http_origin = token_origin
    end

    @token_http
  end

  def self.token_mutex
    @token_mutex ||= Mutex.new
  end

  def self.extract_token_payload(payload)
    return [nil, nil] unless payload.is_a?(Hash)

    candidates = [payload, payload['data'], payload[:data]].select { |v| v.is_a?(Hash) }
    candidates.each do |item|
      token = item['accessToken'] || item[:accessToken] || item['access_token'] || item[:access_token]
      expire_seconds = item['expireSeconds'] || item[:expireSeconds] || item['expiresIn'] || item[:expiresIn] || item['expires_in'] || item[:expires_in]
      return [token, expire_seconds] if token && expire_seconds
    end

    [nil, nil]
  end

  def self.extract_token_error(payload)
    return nil unless payload.is_a?(Hash)

    code = payload['code'] || payload[:code]
    msg = payload['msg'] || payload[:msg]
    sub_code = payload['subCode'] || payload[:subCode]
    sub_msg = payload['subMsg'] || payload[:subMsg]
    details = [msg, sub_code, sub_msg].reject { |v| v.to_s.empty? }.join(' / ')

    return nil if code.to_s.empty? && details.to_s.empty?

    success_codes = %w[0 200 00000 success SUCCESS]
    if !code.to_s.empty? && !success_codes.include?(code.to_s)
      return "code=#{code}#{details.to_s.empty? ? '' : " / #{details}"}"
    end

    details
  end
end
