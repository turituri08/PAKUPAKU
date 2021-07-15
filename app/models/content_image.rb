# frozen_string_literal: true

class ContentImage < ApplicationRecord
  belongs_to :content
  attachment :image
end
