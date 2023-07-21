class Review < ApplicationRecord
  belongs_to :book
  validates :comment, presence: true
  validates :star, presence: true, numericality: { less_than_or_equal_to: 10 }
end
