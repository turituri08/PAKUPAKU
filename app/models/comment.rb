# frozen_string_literal: true

class Comment < ApplicationRecord
  validates  :user_id,    presence: true
  validates  :content_id, presence: true
  validates  :comment,    presence: true

  belongs_to :user
  belongs_to :content
  has_many   :notifications, dependent: :destroy
end
