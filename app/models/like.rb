# frozen_string_literal: true

class Like < ApplicationRecord
  validates :user_id,     presence: true
  validates :content_id,  presence: true

  belongs_to :user
  belongs_to :content
end
