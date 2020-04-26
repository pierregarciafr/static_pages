class SessionsController < ApplicationController

  def new
  end

  def create # !important : garder le @ devant @user
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? # pourquoi pas de (@current_user) ?
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

end

