class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      actived_user user
    else
      flash.now[:danger] = t "controllers.sessions_controller.invalid_login"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def actived_user user
    if user.activated
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = t "controllers.sessions_controller.not_activated"
      redirect_to login_path
    end
  end
end
