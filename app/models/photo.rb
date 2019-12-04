class Photo < ApplicationRecord

  belongs_to :job
  has_one :zone, class_name: "Staff", foreign_key: :id, primary_key: :zone_id
  has_one :eq, class_name: "Staff", foreign_key: :id, primary_key: :eq_id
  has_one_attached :image
  validate :precense_image
  def precense_image
    if self.image.attached?
    else
      self.errors.add(:image, "Изображение должно быть добавлено")
    end
  end
end
