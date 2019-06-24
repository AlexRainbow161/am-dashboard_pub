class User < ApplicationRecord
  default_scope { includes(:jobs, :user_default_queries) }
  belongs_to :user_role, foreign_key: :role_id
  has_many :jobs
  has_many :user_default_queries

  def firstname
    fullname.split.first
  end
end
