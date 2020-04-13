ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # include ApplicationHelper

  def is_logged_in? # cloning logged_in? for tests
    !session[:user_id].nil?
  end

  # login as a particular user
  def log_in_as(user) # cloning log_in(user) for tests
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest # for chapter 10
  # login as a particular user
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: {session: { email: user.email,
                                         password: password,
                                         remember_me: remember_me
                                        }
                              }
  end
end
