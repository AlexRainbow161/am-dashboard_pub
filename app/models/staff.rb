class Staff < ApplicationRecord
  enum staff_type: {Оборудование: 0, Зона: 1}
  validates :name, :staff_type, presence: true
  before_save :empty_zone_id
  scope :equipment, -> {where staff_type: 0}
  scope :zones, -> {where staff_type: 1}
  scope :name_search, ->(name) {where "name like (?)", "%#{name}%"}
  has_one :equpments, class_name: 'Staff', foreign_key: :zone_id
  belongs_to :zone, class_name: 'Staff', optional: true


  private
    def empty_zone_id
      if self.staff_type == 'Зона'
        self.zone_id = nil
      end
    end
end
