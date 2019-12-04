class JobNotifyMailer < ApplicationMailer
  include ApplicationHelper
  add_template_helper(ApplicationHelper)

  def notify_admin
    @job = params[:job]
    @email = params[:email]
    @url = job_url(@job)
    make_bootstrap_mail(to: @email, subject: "#{subject_prepend} #{@job.user.fullname} изменил статус работы на #{@job.status.name}")
  end

  def notify_user
    @job = params[:job]
    @who = params[:who]
    @url = job_url(@job)
    make_bootstrap_mail(to: @job.user.email, subject: "#{subject_prepend} #{@job.job_type.name} от #{human_date(@job.start_date)}")
  end
end
