module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user) # creation des cookies
    user.remember # methode de classe
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id]) # une session existe / est ouverte
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # un cookie avec user_id existe
      user = User.find_by(id: user_id)
      # user = User.where(id: user_id).first
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out # pourquoi pas de (user)
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location or default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  #Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
