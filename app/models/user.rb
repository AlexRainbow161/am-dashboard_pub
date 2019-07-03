class User < ApplicationRecord
  default_scope { includes(:jobs, :user_role) }
  scope :admins_only, -> { where(role_id: 1) }
  scope :exclude_user, -> (user_id) { where.not(id: user_id) }
  belongs_to :user_role, foreign_key: :role_id
  has_many :jobs
  has_many :user_default_queries

  def firstname
    fullname.split.first
  end

  def admin?
    case self.user_role.role
    when 'Admin'
      true
    when 'User'
      false
    else
      false
    end
  end
end
