class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :alert, :unopened
  has_one :user
end
