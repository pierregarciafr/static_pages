require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @user = users(:lana)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    # confirm that pagination is present on the page
    assert_select 'div.digg_pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  # test 'index list should select activated users' do
  #   log_in_as(@admin)
  #   get users_path
  #   assert_select 'div.digg_pagination'
  #   first_page_of_users = User.paginate(page: 1)
  #   first_page_of_users.each do |user|
  #     assert_select 'a[href=?]', user_path(user), text: user.name
  #     assert_equal user.validated, true
  #   end
  # end
end

