module Admin
  class Admin::UsersController < AdminController
    before_action :admin?, except: [:index]
    def index
      @users = User.all
      @users = @users.search_by_name(params[:search]) if params[:search] && !params[:search].empty?
      respond_to do |format|
        format.js
        format.html
      end
    end
    def new
      @user = User.new
      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
    end

    private
    def user_params
      params.require(:user).permit(:username, :email, :fullname, :role_id)
    end
  end
end

