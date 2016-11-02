module Oauth
  class Vk
    include HTTParty

    base_uri 'https://api.vk.com'

    def get_user_data(access_token)
      required_fields = %W{uid first_name last_name}
      options = { query: { access_token: access_token, fields: 'email' } }
      response = self.class.get('/method/users.get', options)
      return false if response.parsed_response.keys.include?('error') || (required_fields - response.parsed_response['response'].first.keys).any?
      user = response.parsed_response['response'].first
      {
        'id' => user['uid'],
        'name' => "#{user['first_name']} #{user['last_name']}",
        'email' => user.try(:[], 'email')
      }
    end
  end
end
