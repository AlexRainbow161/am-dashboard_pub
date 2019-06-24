class UserController < ApplicationController
  before_action :set_user, only: [:index, :show]

  def index; end

  def show; end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
