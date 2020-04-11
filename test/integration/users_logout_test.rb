require 'test_helper'

class UsersLogoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should close the session when logout" do
    # on va sur la page login
    get login_path
    # on poste les params de connextion
    assert_template 'sessions/new'
    post login_path params:{ session: { email: @user.email,
                             password: 'password'
                            }
                 }
    assert is_logged_in?
    # on verifie qu'on est sur la bonne redirection
    assert_redirected_to @user
    follow_redirect!
    # on  verifie qu'une session est ouverte
    # on verifie que la page rendue est la bonne
    assert_template 'users/show'
    # on verifie que le lien logout est présent
    assert_select 'a[href=?]', logout_path
    # on procede au logout
    delete logout_path
    # on verifie que current user n'existe plus
    assert_not is_logged_in?
    assert_redirected_to root_url
    # assert_redirected_to logout_path
    follow_redirect!
    # on verifie que la session n'existe plus
    assert_template 'static_pages/home'

  end

end
