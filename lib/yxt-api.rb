require 'http'
require 'json'
require 'digest'
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
  # @return [HTTP::Response]
  def self.request(resource, options = {})
    @http ||= HTTP.persistent @base_url

    json_params = with_signature(options)

    res = @http.post("#{base_url}/#{resource}", json: json_params)

    case res.code
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
