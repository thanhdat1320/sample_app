class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new show)
  before_action :load_user, except: %i(create new index)
  before_action :correct_user, only: %i(edit update show)
  before_action :check_user_admin, only: :destroy

  def show; end

  def edit; end

  def index
    @users = User.page(params[:page]).per(Settings.paginate.page_5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users_controller.check_mail"
      redirect_to root_url
    else
      flash.now[:warning] = t "controllers.users_controller.fail"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "controllers.users_controller.updated"
      redirect_to @user
    else
      flash.now[:warning] = t "controllers.users_controller.updated_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users_controller.deleted"
    else
      flash[:danger] = t "controllers.users_controller.delete_fail"
    end
    redirect_to users_url
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "controllers.users_controller.logged_in_user"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "controllers.users_controller.user_not_found"
    redirect_to new_user_path
  end

  def check_user_admin
    redirect_to(root_url) unless current_user.admin?
  end

  def user_params
    params
      .require(:user).permit :name, :email, :password, :password_confirmation
  end
end
