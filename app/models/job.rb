class Job < ApplicationRecord
  default_scope {includes(:user).order(start_date: :desc)}
  scope :with_accepted, ->(accepted) {where(accepted: accepted)}
  belongs_to :store, foreign_key: :store_code
  belongs_to :job_type
  belongs_to :user
  belongs_to :status
  has_one :job_info

  validates :start_date, presence: {message: "Дата начала не может быть пустой"}

  def self.to_csv
    atrributes = %w{Тип Статус Магазин Инженер Дата}
    CSV.generate(headers: true, col_sep: ";", encoding: "cp1251") do |csv|
      csv << atrributes
      all.each do |job|
        csv << [job.job_type.name, job.status.name, job.store.name, job.user.fullname, (job.end_date ? job.end_date : job.start_date)]
      end
    end
  end
end
