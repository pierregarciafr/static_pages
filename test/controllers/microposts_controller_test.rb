require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @another_user = users(:archer)
    @micropost = microposts(:orange)
  end

  test 'should abort micropost creation if not logged_in' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Test" } }
    end
    assert_redirected_to login_url
  end

  test 'should allow creation if logged in' do
    log_in_as(@user)
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: "Test", user_id: @user.id } }
    end
  end

  test 'should abort micropost destroy if not logged_in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test 'should abort destroy if logged in but destroyed micropost belongs to another user' do
    log_in_as(@user)
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@micropost)
    end
  end

  test "should abort destroy of another user's post" do
    log_in_as(@another_user)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

end
