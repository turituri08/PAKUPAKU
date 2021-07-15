# frozen_string_literal: true

class Favorite < ApplicationRecord
  validates :user_id,     presence: true
  validates :content_id,  presence: true

  belongs_to :user
  belongs_to :content
end
