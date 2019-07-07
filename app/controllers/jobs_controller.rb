class JobsController < ApplicationController
  before_action :job_params, only: [:create]
  before_action :set_job, only: [:show, :destroy, :edit, :update, :done]
  before_action :check_edit_job, only: [:edit, :update, :destroy]
  def index
    @jobs = Job.all.paginate(page: params[:page], per_page: 30).order(created_at: :desc)
  end
  def new
    @job = Job.new
    @store = Store.find(params[:store_code])
    if @store.jobs.any? && @store.jobs.first.status.name == "Запланировано" && !current_user.admin?
      redirect_back fallback_location: :back, danger: "Вы не можете создать новый выезд, так как предыдущий еще не завершен"
    end
    respond_to do |format|
      format.html
    end
  end
  def create
    job = Job.create(job_params)
    if job.save
      if current_user.admin?
        notify_user(job)
      else
        notify_admins(job)
      end
      redirect_to store_path(job.store)
    else
      flash[:danger] = "Ошибка сохранения #{job.errors.full_messages}"
      redirect_back fallback_location: :back
    end
  end

  def show; end

  def edit; end

  def update
    if @job.update(job_params)
      redirect_back fallback_location: :back, success: "Работа обновлена"
    else
      redirect_back fallback_location: :back, danger: "Ошибка сохранения"
    end
  end

  def destroy
    store_code = @job.store.code
    if @job.destroy
      redirect_to store_path(store_code), success: "Работа успешно удалена"
    end
  end

  def done
    if current_user.admin? && @job.accepted || current_user.id == @job.user_id && @job.accepted
      if @job.update(status_id: 3)
        redirect_back fallback_location: :back, success: "Работа завершена"
      else
        redirect_back fallback_location: :back, danger: "Ошибка завершения работы"
      end
    else
      redirect_back fallback_location: :back, danger: "Ошибка завершения работы"
    end
  end

  private

  def job_params
    params.require(:job).permit(:start_date, :end_date, :store_code, :user_id, :status_id, :job_type_id, :accepted, :historical)
  end

  def set_job
    begin
      @job = Job.find(params[:id])
      @store = @job.store
    rescue
      redirect_to root_path, danger: "Нет работы с таким id"
    end

  end

  def notify_admins(job)
    User.admins_only.each do |user|
      JobNotifyMailer.with(job: job, email: user.email).notify_admin.deliver_later
    end
  end

  def notify_user(job)
    JobNotifyMailer.with(job: job, who: current_user).notify_user.deliver_later
  end

  def check_edit_job
    if @job.accepted && !current_user.admin?
      redirect_back fallback_location: :back, danger: "Вы не можете изменить подтвержденную работу"
    end
  end
end
