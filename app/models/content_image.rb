class ContentImage < ApplicationRecord
  belongs_to :content
  attachment :image
end
