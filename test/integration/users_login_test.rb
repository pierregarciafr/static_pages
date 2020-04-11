require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "should dismiss the flash after rendering" do
  # aller sur la page de la nouvelle session
  get login_path
  # valider le render de la view new
  assert_template 'sessions/new'
  # envoyer POSTer des donnees non valides
  post login_path, params: { session: { email: '', password: '' } }
  # non valide => verifier que le flash est cree
  assert_template 'sessions/new'
  # verifier que la new est bien rendered à nouveau
  assert_not flash.empty?
  # aller sur la homepage (root)
  get root_path
  # verifier que la flash est vide
  assert flash.empty?
  end

  test 'valid login information' do
    # aller sur la page de login
    get login_path
    # remplir le formulaire avec le mail et le bon mot de passe
    # poster les donnees valides
    assert_template 'sessions/new'
    post login_path params: { session: { email: @user.email,
                                         password: 'password'
                                       }
                            }
    # aller sur la page de session ouverte
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # verifier que le lien login n'est plus sur le render de la view
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', login_path, count: 0
    # verifier que le lien logout est sur le view render
    # verifier que le lien vers user show est sur la view render
  end

  test 'login valid email / invalid password' do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email: @user.email,
                                         password: 'invalid'
                                       }
                            }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?

  end

end
