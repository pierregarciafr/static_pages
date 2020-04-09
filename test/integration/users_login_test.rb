require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
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
end
