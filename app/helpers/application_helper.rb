module ApplicationHelper
  include Pagy::Frontend
  def human_date(date)
    if date
      d = Date.strptime(date.to_s, '%Y-%m-%d')
      time = d.strftime('%d.%m.%Y')
    else
      time = "Не указана дата"
    end
  end
end
