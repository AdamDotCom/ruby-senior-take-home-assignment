require 'httparty'

module Vandelay
  module Integrations
    class VendorOneClient
      include HTTParty

      format :json
      # debug_output $stdout

      def initialize(config)
        self.class.base_uri "#{config.dig('integrations', 'vendors', 'one', 'api_base_url')}"
        self.authenticate
      end

      def authenticate
        response = self.class.get("/auth/1").parsed_response
        self.class.headers['Authorization'] = "Bearer #{response.dig('token')}"
      end

      def patients(id = nil)
        self.class.get("/patients/", query: { id: id }.compact).parsed_response
      end
    end
  end
end
