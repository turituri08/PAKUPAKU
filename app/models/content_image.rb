class ContentImage < ApplicationRecord
  validates :content_id, presence: true
  
  belongs_to :content
  attachment :image
end
