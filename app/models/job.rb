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
  has_many :patch_panels
  has_many :photos
  has_many :registrators

  validates :start_date, presence: {message: "Дата начала не может быть пустой"}
  validate :duplicate_one_time_job?, on: :create
  validate :check_past
  validate :check_duplicate
  before_save
  #before_save :create_in_sn

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
    if self.accepted_changed? && self.accepted_change.last && self.status_id == 1 && !self.historical
      ServiceNowApi::ServiceNowApiHelper.create_sn_ppr(self.user.username, self.store.rozn,
                                                       self.start_date.strftime("%d.%m.%Y"),
                                                       self.comment,
                                                       self.job_type.name,
                                                       self.status.name)
    end
  end
  def duplicate_one_time_job?
    if self.store.jobs.not_regular.any?
      if self.store.jobs.not_regular.first.job_type.name == self.job_type.name
        errors.add(:Тип_работы, "Нельзя создать #{job_type.name} поверх #{self.store.jobs.not_regular.first.job_type.name}")
      end
    end
  end

  def check_past
    if !self.historical && self.start_date_changed?
      if self.start_date < Date.today
        errors.add(:Дата_начала, "Вы не можете создать работу в прошлом.")
      end
    end
  end

  def check_duplicate
    if self.store.jobs.any? && self.start_date_changed?
      if self.store.jobs.where(start_date: self.start_date, user_id: self.user_id).count > 0
        errors.add(:Дата_начала, "Вы не можете создать две работы в одном магазине в один день.")
      end
    end
  end
end
