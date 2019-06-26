class AdminController < ApplicationController
  before_action :admin?
  before_action :permit_params
  def index; end

  def search
    @users = Ldap::LdapHelper.search_by_username(params[:username])
    respond_to do |format|
      format.html {render :index}
      format.json { render json: users}
    end
  end
  private

  def admin?
    redirect_back fallback_location: :back, danger: "У вас нет прав для просмотра этой страницы" unless current_user.admin?
  end

  def permit_params
    params.permit(:username, :role)
  end
end
