module Admin
  class AdminController < ApplicationController
    layout 'admin'
    before_action :admin?

    def index; end

    private
    def admin?
      redirect_to root_path, danger: "У вас нет прав на просмотр данной страницы." unless current_user.admin?
    end
  end
end
