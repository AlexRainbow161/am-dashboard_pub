class JobNotifyMailer < ApplicationMailer
  include ApplicationHelper
  default from: 'AM-DASH Notify <clientsupport@gloria-jeans.ru>'

  def notify_admin
    @job = params[:job]
    @email = params[:email]
    @url = job_url(@job)
    mail(to: @email, subject: "#{@job.user.fullname} Запланировал работу")
  end

  def notify_user
    @job = params[:job]
    @who = params[:who]
    @url = job_url(@job)
    mail(to: @job.user.email, subject: "#{@job.job_type.name} от #{human_date(@job.start_date)}")
  end
end
