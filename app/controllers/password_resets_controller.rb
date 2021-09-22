class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update create)
  before_action :valid_user, :check_expiration, only: %i(edit update)
  before_action :check_pass_empty, only: %i(update)

  def new; end

  def edit; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "controllers.password_resets_controller.send_mail_reset"
    redirect_to root_url
  end

  def update
    if @user.update password_reset_params
      flash[:success] = t "controllers.password_resets_controller.reset_success"
      redirect_to login_url
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email:
      params[:email] ||  params[:password_reset][:email].downcase
    return if @user

    flash[:danger] = t "controllers.password_resets_controller.user_not_found"
    render :new
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "controllers.password_resets_controller.invalid_user"
    redirect_to root_url
  end

  def password_reset_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "controllers.password_resets_controller.password_expired"
    redirect_to new_password_reset_url
  end

  def check_pass_empty
    return if params[:user][:password].present?

    @user.errors.add(:password, t("controllers.password_resets_controller
      .password_empty"))
    render :edit
  end
end
