class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
end
