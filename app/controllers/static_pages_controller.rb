class StaticPagesController < ApplicationController

  def root
  end

  def home
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end

end
