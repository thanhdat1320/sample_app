class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "controllers.users_controller.user_not_found"
    redirect_to new_user_path
  end

  def new
    @user = User.new
  end

  def index
    @users = User.page(params[:page]).per(Settings.paginate.page_5)
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "controllers.users_controller.welcome"
      redirect_to @user
    else
      flash.now[:warning] = t "controllers.users_controller.fail"
      render :new
    end
  end

  private

  def user_params
    params
      .require(:user).permit :name, :email, :password, :password_confirmation
  end
end
