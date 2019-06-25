class Job < ApplicationRecord
  default_scope {includes(:user).order(start_date: :desc)}
  belongs_to :store, foreign_key: :store_code
  belongs_to :job_type
  belongs_to :user
  belongs_to :status
  has_one :job_info
end
