# frozen_string_literal: true

class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :content, :date, :time
  has_one :user
end
