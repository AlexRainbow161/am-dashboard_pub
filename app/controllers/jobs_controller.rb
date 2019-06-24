class JobsController < ApplicationController
  before_action :job_params, only: [:create]
  before_action :set_job, only: [:show]
  def index
    @jobs = Job.all.paginate(page: params[:page], per_page: 30).order(created_at: :desc)
  end
  def new
    @job = Job.new
    @store = Store.find(params[:store_code])
  end
  def create
    job = Job.create!(job_params)
    if job.save
      redirect_to store_path(job.store)
    else
      flash[:danger] = "Ошибка сохранения"
      redirect_to jobs_path
    end
    # redirect_to new_store_job_path(Store.find(1095))
  end

  def show
  end

  private

  def job_params
    params.require(:job).permit(:start_date, :end_date, :store_code, :user_id, :status_id, :job_type_id)
  end

  def set_job
    @job = Job.find(params[:id])
  end
end
