class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :author_id, :created_at, :updated_at

  has_many :skills, if: :include_skills?

  def include_skills?
    instance_options.fetch(:include_skills, true)
  end
end
