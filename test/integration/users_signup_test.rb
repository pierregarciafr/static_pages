require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def is_logged_in?
    !session[:user_id].nil?
  end

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
    assert is_logged_in?
    assert_not flash.empty?
  end
end
