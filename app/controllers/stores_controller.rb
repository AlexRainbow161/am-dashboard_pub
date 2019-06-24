class StoresController < ApplicationController
  before_action :set_store, only: [:show]
  before_action :query_params, only: [:index]
  def index
    @stores = Store.all.paginate(page: params[:page], per_page: 30).order(name: :asc)
    @stores = @stores.by_name(params[:name]) if params[:name] && !params[:name].empty?
    @stores = @stores.by_region(params[:region]) if params[:region] && !params[:region].empty?
    @stores = @stores.by_status(params[:s_stat]) if params[:s_stat] && !params[:s_stat].empty?
    @stores = @stores.by_job_date(params[:date_start], params[:date_end]) if params[:date_start] || params[:date_end]
    @stores = @stores.by_user_name(params[:user_name]) if params[:user_name] && !params[:user_name].empty?
  end
  def show; end

  private

  def set_store
    @store = Store.find(params[:code])
  end
  def query_params
    params.permit(:region, :name, :s_stat, :user_name, :date_start, :date_end, :code)
  end
end
