class Content < ApplicationRecord
  validates  :user_id,    presence: true
  validates  :body,       presence: true
  validates  :target_age, presence: true
  
  belongs_to :user
  has_many :content_images, dependent: :destroy
  accepts_attachments_for :content_images, attachment: :image
  
end
