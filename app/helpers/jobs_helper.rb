module JobsHelper
  def last_job(store)
    last_job = store.jobs.order(created_at: :desc).first
  end

  def human_date(date)
    d = Date.strptime(date.to_s, '%Y-%m-%d')
    time = d.strftime('%d.%m.%Y')
  end

  def first_name(fullname)
    name = fullname.split().first
  end

  def select_options_job_type
    job_types = JobType.all
    select = []
    job_types.each do |job_type|
      select << [job_type.name, job_type.id]
    end
    select
  end

  def select_options_job_status
    select = []
    Status.all.each do |status|
      select << [status.name, status.id]
    end
    select
  end

  def type_color(job_type)
    case job_type
    when "Открытие"
      color = "success"
    when "Закрытие"
      color = "danger"
    when "Профилактика"
      color = "primary"
    end
  end
end
