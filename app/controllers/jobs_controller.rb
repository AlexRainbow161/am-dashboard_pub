class JobsController < ApplicationController
  before_action :job_params, only: [:create]
  before_action :set_job, only: [:show, :destroy, :edit, :update]
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

  def show; end

  def edit; end

  def update
    if @job.update(job_params)
      redirect_to job_path(@job), success: "Работа обновлена"
    else
      redirect_to job_path(@job), danger: "Ошибка сохранения"
    end
  end

  def destroy
    store_code = @job.store.code
    if @job.destroy
      redirect_to store_path(store_code), success: "Работа успешно удалена"
    end
  end

  private

  def job_params
    params.require(:job).permit(:start_date, :end_date, :store_code, :user_id, :status_id, :job_type_id, :accepted)
  end

  def set_job
    @job = Job.find(params[:id])
    @store = @job.store
  end
end
