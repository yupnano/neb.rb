# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Request
    attr_reader :action, :url, :payload

    def initialize(action, url, payload = {}, headers = {})
      @action  = action
      @url     = url
      @payload = payload
      @headers = headers.blank? ? default_headers : headers
    end

    def to_s
      "#{self.class}{action=#{action}, url=#{url}, payload=#{payload}}"
    end

    def execute
      Neb.logger.debug(self.to_s)
      Response.new(
        ::RestClient::Request.execute(
          method:  action,
          url:     url,
          payload: payload.camelize_keys(:lower).to_json,
          headers: { content_type: :json, accept: :json }
        )
      )
    end

    private

      def default_headers
        { content_type: :json, accept: :json }
      end
  end
end