require 'httparty'

module Vandelay
  module Integrations
    class VendorTwoClient
      include HTTParty

      format :json
      # debug_output $stdout

      def initialize(config)
        self.class.base_uri "#{config.dig('integrations', 'vendors', 'two', 'api_base_url')}"
        self.authenticate
      end

      def authenticate
        response = self.class.get("/auth_tokens/1").parsed_response
        self.class.headers['Authorization'] = "Bearer #{response.dig('auth_token')}"
      end

      def patients(id = nil)
        self.class.get("/records/", query: { id: id }.compact).parsed_response
      end
    end
  end
end
