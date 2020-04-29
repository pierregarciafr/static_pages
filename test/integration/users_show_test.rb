require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @activated = users(:lana)
    @non_activated = users(:malory)
  end

  test 'should not display a user path if this user is not activated' do
    log_in_as(@activated)
    get user_path(@non_activated)
    follow_redirect!
    assert_template 'users/index'
  end

  test 'should display a user path if this user is activated' do
    log_in_as(@activated)
    get user_path(@non_admin)
    assert_template 'users/show'
  end
end
