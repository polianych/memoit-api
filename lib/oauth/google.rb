module Oauth
  class Google
    include HTTParty
    base_uri 'https://www.googleapis.com'

    def get_user_data(access_token)
      required_fields = %W{id name}
      options = { query: { access_token: access_token, fields: 'email,name,id' }, headers: { "Authorization" => "Bearer #{access_token}" } }
      response = self.class.get('/userinfo/v2/me', options)
      return false if response.code > 399 || (required_fields - response.parsed_response.keys).any?
      response.parsed_response
    end
  end
end
