class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
#    if user && user.authenticate(params[:session][:password])
    if user&.authenticate(params[:session][:password])
      # log_in(user)
      redirect_to user

    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out # pourquoi pas de (@current_user) ?
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

end

