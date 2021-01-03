# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :id, :title, :category, :content
  has_one :user
end
