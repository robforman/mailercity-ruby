require "faraday"
require "mailercity/helper"
require "mailercity/version"
require 'mailercity/errors/authentication_error'

module Mailercity
  @@api_base = 'https://mailercity.onthecity.org'
  @@api_key = nil

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

  def self.request(path, params)
    raise AuthenticationError.new('No API key provided.  (HINT: set your API key using "Mailercity.api_key = <API-KEY>".') unless api_key
    response = Faraday.post(api_url(path), params, "X-Api-Key" => Mailercity.api_key)
    # TODO: CATCH ALL EXCEPTIONS (like URI::InvalidURIError) AND RAISE MY OWN ERROR
  end

  def self.const_missing(const_name)
    new_class = Class.new(super_class=Message)

    # Non-obvious: we assign it to a const in order to name.
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
      response = Mailercity.request("/#{mailer_name}/#{template}", params)
      response.status == 201
    end

    private

    def self.method_missing(method_name, args, &block)
      new(template: method_name, params: args)
    end
  end
end
