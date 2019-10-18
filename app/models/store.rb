class Store < ApplicationRecord
  self.primary_key = :code
  default_scope { where("name NOT LIKE '%Ecomm%' AND name NOT LIKE '%TMALL%' AND baseidd IS NOT null") }
  scope :by_name, ->(name) { where("name LIKE (?)", "%#{name}%") }
  scope :name_ordered, -> {order(name: :asc)}
  scope :by_region, ->(region) { where region: region }
  scope :by_status, ->(s_stat) { where s_stat: s_stat }
  scope :jobs_new_to_old, -> { joins("left join (
                                select * from jobs j where start_date =
                                (select max(start_date) from jobs where store_code = j.store_code))
                                as jobss on jobss.store_code = stores.code").order('jobss.start_date desc') }
  scope :by_job_date, ->(date_start = nil, date_end = nil) {
    date_start ||= Job.last.start_date
    date_end ||= Time.zone.now
    joins(:jobs).where(jobs: {start_date: date_start..date_end })
  }
  scope :by_user_name, ->(user_name) { joins(:jobs).where(jobs: { user_id: User.find_by(username: user_name.downcase).id }) }
  scope :by_job_stat, ->(job_stat_id) { joins(:jobs).where(jobs: {status_id: job_stat_id}) }
  scope :by_job_type, ->(job_type_id) { joins(:jobs).where(jobs: {job_type_id: job_type_id}) }
  has_many :jobs, foreign_key: :store_code

  def rozn
    self.email.split('@').first if self.email
  end
end
