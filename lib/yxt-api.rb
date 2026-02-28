# frozen_string_literal: true

require 'httpx'
require 'json'
require 'digest'
require 'securerandom'
require 'yxt-api/job_level'
require 'yxt-api/organization_unit'
require 'yxt-api/position'
require 'yxt-api/user'
require 'yxt-api/version'

module Yxt
  class YxtAPI_Error < RuntimeError; end

  class << self
    attr_accessor :apikey
    attr_accessor :secretkey

    attr_accessor :base_url
  end

  # Make an HTTP request with the given verb to YXT API server
  # @param resource [String]
  # @option options [Hash]
  # @return [HTTPX::Response]
  def self.request(resource, options = {})
    if @http.nil? || @http_origin != base_url
      @http = HTTPX.with(origin: base_url)
      @http_origin = base_url
    end

    json_params = with_signature(options)

    res = @http.post("/#{resource}", json: json_params)
    attach_response_compatibility!(res)
    business_code = extract_business_code(res)

    case business_code
    when 40101
      raise YxtAPI_Error, '授权码签名无效！'
    when 50001
      raise YxtAPI_Error, '未授权该API！'
    when 50002
      raise YxtAPI_Error, 'API 功能未授权！'
    when 60100
      raise YxtAPI_Error, '服务内部错误！'
    when 60101
      raise YxtAPI_Error, '业务处理错误！'
    end

    res
  end

  private_class_method

  def self.attach_response_compatibility!(response)
    response.define_singleton_method(:code) { status } unless response.respond_to?(:code)
    response.define_singleton_method(:parse) { json } unless response.respond_to?(:parse)
  end

  def self.extract_business_code(response)
    payload = response.json
    code = payload['code'] || payload[:code]
    code.is_a?(String) ? code.to_i : code
  rescue StandardError
    nil
  end

  def self.with_signature(options = {})
    salt = SecureRandom.hex(4) # like "301bccce"
    signature = Digest::SHA256.hexdigest("#{secretkey}#{salt}")

    {
      apikey: apikey,
      salt: salt,
      signature: signature
    }.merge options
  end
end
