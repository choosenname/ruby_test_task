class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validates :date, presence: true
end
