class Book < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :release, presence: true
end
