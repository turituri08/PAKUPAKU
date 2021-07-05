class Content < ApplicationRecord
  validates  :user_id,    presence: true
  validates  :body,       presence: true
  validates  :target_age, presence: true
  
  belongs_to :user
  has_many   :content_images, dependent: :destroy
  accepts_attachments_for :content_images, attachment: :image
  has_many   :comments,       dependent: :destroy
  has_many   :likes,          dependent: :destroy
  has_many   :favorites,      dependent: :destroy
  
  #user_idが存在する確認
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
