class UserController < ApplicationController
  before_action :user_params, only: [:create, :update]
  before_action :set_user, only: [:show, :edit, :update]
  def index; end

  def show; end

  def edit; end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_back fallback_location: :back, success: "Пользователь создан"
    else
      redirect_back fallback_location: :back, danger: "Пользователь не создан"
    end
  end

  def update
    if @user.update(user_params)
      redirect_back fallback_location: :back, success: "Пользователь обновлен"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role_id, :fullname, :username, :email)
  end

end
