class Skill < ApplicationRecord
  has_and_belongs_to_many :courses

  validates :name, presence: true
end
