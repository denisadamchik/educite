class Course < ApplicationRecord
  belongs_to :author
  has_and_belongs_to_many :skills

  validates :title, presence: true
end
