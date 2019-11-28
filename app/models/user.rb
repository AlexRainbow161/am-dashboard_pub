class User < ApplicationRecord
  default_scope { includes(:jobs, :user_role, :events) }
  scope :admins_only, -> { where(role_id: 1) }
  scope :exclude_user, -> (user_id) { where.not(id: user_id) }
  scope :search_by_name, -> (name) {where "fullname like (?)", "%#{name}%"}
  belongs_to :user_role, foreign_key: :role_id
  has_many :jobs
  has_many :user_default_queries
  has_many :events

  def firstname
    fullname.split.first
  end

  def name
    name_reg = %r"\((.*?)\)"
    match = self.fullname.match name_reg
    if match
      name = match.captures.first
    else
      name = self.fullname.split.first
    end
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
