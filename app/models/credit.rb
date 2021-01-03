# frozen_string_literal: true

class Credit < ApplicationRecord
  belongs_to :user, foreign_key: 'created_user_id'
  validates :amount, presence: true
end
