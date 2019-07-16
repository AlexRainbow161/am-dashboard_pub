class Staff < ApplicationRecord
  enum staff_type: {Оборудование: 0, Зона: 1}
  validates :name, :staff_type, presence: true
  scope :equipment, -> {where staff_type: 0}
  scope :zones, -> {where staff_type: 1}
  scope :name_search, ->(name) {where "name like (?)", "%#{name}%"}
end
