require 'http'
require 'json'
require 'digest'
require 'yxt-api/organization_unit'
require 'yxt-api/position'
require 'yxt-api/user'
require 'yxt-api/version'

module Yxt
  class << self
    attr_accessor :apikey
    attr_accessor :secretkey

    attr_accessor :base_url
  end

  # Make an HTTP request with the given verb to easemob server
  # @param resource [String]
  # @option options [Hash]
  # @return [HTTP::Response]
  def self.request(resource, options = {})
    @http ||= HTTP.persistent @base_url

    json_params = with_signature(options)

    res = @http.post("#{base_url}/#{resource}", json: json_params)

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
