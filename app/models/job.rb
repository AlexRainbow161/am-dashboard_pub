class Job < ApplicationRecord
  default_scope {includes(:user).order(start_date: :desc)}
  scope :with_accepted, ->(accepted) {where(accepted: accepted)}
  belongs_to :store, foreign_key: :store_code
  belongs_to :job_type
  belongs_to :user
  belongs_to :status
  has_one :job_info

  validates :start_date, presence: {message: "Дата начала не может быть пустой"}
end
