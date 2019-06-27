class Store < ApplicationRecord
  self.primary_key = :code
  default_scope { includes(:jobs).where("name NOT LIKE '%Ecomm%' AND name NOT LIKE '%TMALL%'") }
  scope :by_name, ->(name) { where("name LIKE (?)", "%#{name}%") }
  scope :by_region, ->(region) { where region: region }
  scope :by_status, ->(s_stat) { where s_stat: s_stat }
  scope :by_job_date, ->(date_start = nil, date_end = nil) {
    date_start ||= Job.last.start_date
    date_end ||= Time.zone.now
    joins(:jobs).where(jobs: {start_date: date_start..date_end })
  }
  scope :by_user_name, ->(user_name) { joins(:jobs).where(jobs: { user_id: User.find_by(username: user_name.downcase).id }) }
  scope :by_job_stat, ->(job_stat_id) { joins(:jobs).where(jobs: {status_id: job_stat_id}) }
  scope :by_job_type, ->(job_type_id) { joins(:jobs).where(jobs: {job_type_id: job_type_id}) }
  has_many :jobs, foreign_key: :store_code
end
