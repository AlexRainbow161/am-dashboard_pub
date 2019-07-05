class Job < ApplicationRecord
  include ServiceNowApi
  default_scope {includes(:user).order(start_date: :desc)}
  scope :with_accepted, ->(accepted) {where(accepted: accepted)}
  scope :not_regular, ->{ joins(:job_type).where.not(job_types: {name: "Профилактика"})}
  belongs_to :store, foreign_key: :store_code
  belongs_to :job_type
  belongs_to :user
  belongs_to :status
  has_one :job_info

  validates :start_date, presence: {message: "Дата начала не может быть пустой"}
  validate :duplicate_one_time_job?, on: :create
  before_save :create_in_sn

  def self.to_csv
    atrributes = %w{Тип Статус Магазин Инженер Дата}
    CSV.generate(headers: true, col_sep: ";", encoding: "cp1251") do |csv|
      csv << atrributes
      all.each do |job|
        csv << [job.job_type.name, job.status.name, job.store.name, job.user.fullname, (job.end_date ? job.end_date : job.start_date).strftime("%d.%m.%Y")]
      end
    end
  end
  def comment
    nil
  end

  private
  def create_in_sn
    if self.accepted_changed? && self.accepted_change.last && self.status_id == 1
      ServiceNowApi::ServiceNowApiHelper.create_sn_ppr(self.user.username, self.store.rozn,
                                                       self.start_date.strftime("%d.%m.%Y"),
                                                       self.comment,
                                                       self.job_type.name,
                                                       self.status.name)
    end
  end
  def duplicate_one_time_job?
    if self.store.jobs.any?
      if self.store.jobs.not_regular.first.job_type.name == self.job_type.name
        errors.add(:Тип_работы, "Нельзя создать #{job_type.name} поверх #{job_type.name}")
      end
    end
  end
end
