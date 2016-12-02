require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'not valid nicknames' do
    user = users(:one)
    not_valid_nicknames = [42, "nickname!", "nickname with spaces", "кирилица", "nickname%", "nickname&", "nickname#", "nickname@"]
    not_valid_nicknames.each do |n|
      user.update_attributes(nickname: n)
      assert_not user.valid?
      user.errors.messages.assert_valid_keys(:nickname)
    end
  end

  test 'valid nicknames' do
    user = users(:one)
    not_valid_nicknames = ["nickname_123", "Nickname", "nickname123"]
    not_valid_nicknames.each do |n|
      user.update_attributes(nickname: n)
      assert user.valid?
    end
  end

  test 'uniquiness of nicknames' do
    user1 = users(:one)
    user2 = users(:two)
    user1.update_attributes(nickname: user2.nickname)
    assert_not user1.valid?
  end
end
