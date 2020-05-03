class MicropostsController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:info] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @user = @micropost.user
    if @user == current_user
      @micropost.delete
      flash[:info] = "Post deleted!"
      redirect_to user_path(@user)
    else
      flash[:danger] = "You can't delete this post. "
      flash[:danger] += 'Who do you think you are ?'
      redirect_to user_path(@user)
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

end
