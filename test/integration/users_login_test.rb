require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  # test "should dismiss the flash after rendering" do
  # # aller sur la page de la nouvelle session
  # get login_path
  # # valider le render de la view new
  # assert_template 'sessions/new'
  # # envoyer POSTer des donnees non valides
  # post login_path, params: { session: { email: '', password: '' } }
  # # non valide => verifier que le flash est cree

  # assert_template 'sessions/new'
  # # verifier que la new est bien rendered à nouveau
  # assert_not flash.empty?
  # # aller sur la homepage (root)
  # get root_path
  # # verifier que la flash est vide
  # assert flash.empty?
  # end

  test 'login valid email / invalid password' do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email: @user.email,
                                         password: 'invalid'
                                       }
                            }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid login information followed by logout' do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email: @user.email,
                                         password: 'password'
                                       }
                            }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', login_path, count: 0
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # simulates a user clicking out in the second window
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end
end
