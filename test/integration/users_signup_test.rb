require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test 'new valid user creation' do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user: { name: 'Foo bar',
                                         email: 'foo@valid.com',
                                         password: '123456ABC',
                                         password_confirmation: '123456ABC' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
