module Oauth
  class Facebook
    include HTTParty
    base_uri 'https://graph.facebook.com/v2.6'

    def get_user_data(access_token)
      required_fields = %W{id name email}
      options = { query: { access_token: access_token, fields: 'email,name' } }
      response = self.class.get('/me', options)
      return false if response.code > 399 || (required_fields - response.parsed_response.keys).any?
      response.parsed_response
    end
  end
end
