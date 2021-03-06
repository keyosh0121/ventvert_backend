# frozen_string_literal: true

class ShopListItemSerializer < ActiveModel::Serializer
  attributes :id, :content, :color, :icon
  has_one :user
end
