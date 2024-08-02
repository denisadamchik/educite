class Author < ApplicationRecord
  has_many :courses, dependent: :nullify

  validates :name, presence: true
end
