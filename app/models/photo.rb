class Photo < ApplicationRecord
  belongs_to :job
  belongs_to :staff
  has_one_attached :image
end
