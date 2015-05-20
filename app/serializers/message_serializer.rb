class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :type
  has_one :user
end