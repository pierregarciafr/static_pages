require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in to login" do
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in to login" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update to login if not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                             email: @user.email
                                              }
                                            }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged as a wrong user to root" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged as a wrong user to root" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                                email: @user.email
                                              }
                                            }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect index action to index page' do
    get users_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should not allow admin attribute if edited via the web' do
    log_in_as(@other_user)
    assert_not @other_user.admin? # verifie que admin = false
    patch user_path(@other_user), params: { user: { admin: true } }
    assert_not @other_user.reload.admin? # verifie que admin = true
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do # verifie que User.count ne change pas, avant et apres  l'action 'delete'
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged but not admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
