module Admarkt
  class Api::Client
    class <<self
      attr_reader :config
      attr_accessor :code, :token

      def setup(options)
        @config = options
      end

      def request
        @token ||= new.get_token
      end
    end
    attr_accessor :code
    attr_reader :token

    def initialize
      @client = OAuth2::Client.new(
        self.class.config[:client_id],
        self.class.config[:client_secret],
        site: self.class.config[:site],
        authorize_url: '/accounts/oauth/authorize',
        token_url: '/accounts/oauth/token')
    end

    def authorize_url
      @client.auth_code.authorize_url(redirect_uri: self.class.config[:redirect_uri], scope: 'read write')
    end

    def get_token
      fail(Admarkt::Api::Error, 'access code required') if self.class.code.nil?

      @token = self.class.token = @client.auth_code.get_token(
        self.class.code,
        redirect_uri: self.class.config[:redirect_uri],
        headers: {'Authorization' => "Basic #{Base64.encode64("#{self.class.config[:username]}:#{self.class.config[:password]}")}"}
      )
    end

    def refresh_token
      @token.refresh!
    end
  end
end
