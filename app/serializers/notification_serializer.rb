# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :alert, :unopened
  has_one :user
end
