class JobsController < ApplicationController
  before_action :set_job, only: [:show, :destroy, :edit, :update, :done, :accept, :return_to_work]
  before_action :check_edit_job, only: [:edit, :update, :destroy]
  before_action :admin_acces, only: [:accept]
  def index
    @jobs = Job.all.paginate(page: params[:page], per_page: 30).order(created_at: :desc)
  end
  def new
    @job = Job.new
    @store = Store.find(params[:store_code])
    if @store.jobs.any? && @store.jobs.first.status.name == "В работе" && !current_user.admin?
      redirect_back fallback_location: :back, danger: "Вы не можете создать новый выезд, так как предыдущий еще не завершен"
    end
    respond_to do |format|
      format.html
    end
  end
  def create
    #TODO Переработать отправку сообщений, что бы вынести ее из модели
    @job = Job.new(job_params)
    if @job.save
      if current_user.admin?
        notify_user(@job)
      else
        notify_admins(@job)
      end
      redirect_to store_path(@job.store)
    else
      flash[:danger] = "Ошибка сохранения #{@job.errors.full_messages}"
      redirect_back fallback_location: :back
    end
  end

  def show; end

  def edit; end

  def update
    if @job.update(job_params)
      redirect_back fallback_location: :back, success: "Работа обновлена"
    else
      redirect_back fallback_location: :back, danger: "Ошибка сохранения | #{@job.errors.full_messages}"
    end
  end

  def destroy
    store_code = @job.store.code
    if @job.destroy
      redirect_to store_path(store_code), success: "Работа успешно удалена"
    end
  end

  def return_to_work
    if params[:show_modal]
      respond_to do |format|
        format.js {render partial: "return_to_work_modal"}
      end
    else
      comment = params[:job][:comment]
      if @job.update(job_params)
        notify_user(@job, comment)
        respond_to do |format|
          format.js
        end
      end
    end
  end
  def accept
    #TODO Тоже переработать отправку сообщений возможно в коллбэке before_save
    if @job.update(job_accept_params)
      notify_user(@job)
      redirect_back fallback_location: :back, success: "Статус работы изменен на #{@job.status.name}"
    else
      redirect_back fallback_location: :back, danger: "Ошибка сохранения | #{@job.errors.full_messages}"
    end
  end

  def done
    #TODO Переррабоать отправку сообщений для все модели Job
    if current_user.admin?
      if @job.update(job_done_params)
        redirect_back fallback_location: :back, success: "Статус работы изменен на #{@job.status.name}"
      else
        redirect_back fallback_location: :back, success: "Ошибка завершения | #{@job.errors.full_messages}"
      end
    elsif current_user.id == @job.user.id
      if @job.update(job_done_params)
        notify_admins(@job)
        redirect_back fallback_location: :back, success: "Статус работы изменен на #{@job.status.name}"
      else
        redirect_back fallback_location: :back, success: "Ошибка завершения | #{@job.errors.full_messages}"
      end
    end
  end

  private

  def job_params
    params.require(:job).permit(:start_date, :end_date, :store_code, :user_id, :status_id, :job_type_id, :accepted, :historical)
  end
  #TODO Убрать лишние установки параметры в пользу переноса логики в модель
  def job_done_params
    params.require(:job).permit(:status_id)
  end

  def job_accept_params
    params.require(:job).permit(:status_id, :accepted)
  end

  def set_job
    begin
      @job = Job.find(params[:id])
      @store = @job.store
    rescue
      redirect_to root_path, danger: "Нет работы с таким id"
    end

  end
 #TODO избавиться от методов отправки в контроллере после переноса их в модель
  def notify_admins(job)
    User.admins_only.each do |user|
      Event.create!(user_id: user.id, from_user_id: job.user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1)
      JobNotifyMailer.with(job: job, email: user.email).notify_admin.deliver_later
    end
  end

  def notify_user(job, comment=nil)
    Event.create!(user_id: job.user.id, from_user_id: current_user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
    JobNotifyMailer.with(job: job, who: current_user).notify_user.deliver_later
  end
  #TODO Поискать способ отправить это в модель, хотя это поидее должно быть тут наверное
  def check_edit_job
    if @job.accepted && !current_user.admin? && @job.status_id != 1
      redirect_back fallback_location: :back, danger: "Вы не можете изменить подтвержденную работу"
    end
  end

  def admin_acces
    if !current_user.admin?
      redirect_back fallback_location: :back, danger: "Только администратор может сделать #{action_name}"
    end
  end
end
