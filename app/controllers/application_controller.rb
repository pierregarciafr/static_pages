class ApplicationController < ActionController::Base
  def hello
    render html: 'hello you !'
  end
end
