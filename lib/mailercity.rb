require "faraday"
require "json"
require "mailercity/helper"
require "mailercity/version"
require 'mailercity/errors/authentication_error'

module Mailercity
  @@api_base = 'https://mailercity.onthecity.org'
  @@api_key = nil
  @@perform_deliveries = true

  def self.api_base=(api_base)
     @@api_base = api_base
   end

   def self.api_base
     @@api_base
   end

  def self.api_url(url='')
    @@api_base + url
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.perform_deliveries=(perform_deliveries)
    @@perform_deliveries = perform_deliveries
  end

  def self.perform_deliveries
    @@perform_deliveries
  end


  def self.request(path, args)
    raise AuthenticationError.new('No API key provided.  (HINT: set your API key using "Mailercity.api_key = <API-KEY>".') unless api_key
    payload = {:args => args}
    response = Faraday.post(api_url(path)) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-Api-Key'] = Mailercity.api_key
      req.body = payload.to_json
    end
  end

  def self.const_missing(const_name)
    new_class = Class.new(super_class=Message)

    # Non-obvious: we assign it in order to name it.
    const_set(const_name, new_class)
  end


  class Message
    include Mailercity::Helper
    attr_reader :template, :params

    def initialize(args)
      @template = args.fetch(:template)
      @params = args.fetch(:params)
    end

    def mailer_name
      underscore self.class.name.split(/::/).last
    end

    def deliver
      return true if Mailercity.perform_deliveries == false

      response = Mailercity.request("/#{mailer_name}/#{template}", params)
      response.status == 201
    end

    private

    def self.method_missing(method_name, *args, &block)
      new(template: method_name, params: args)
    end
  end
end
