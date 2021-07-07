class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  validates :name,         presence: true
  validates :sex,          presence: true
  validates :birthday,     presence: true
  validates :user_name,    presence: true
  validates :email,        presence: true,
                           uniqueness: true,
                           format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :child_gender, presence: true
  validates :child_age,    presence: true
  
  has_many  :contents,     dependent: :destroy
  has_many  :comments,     dependent: :destroy
  has_many  :likes,        dependent: :destroy
  has_many  :favorites,    dependent: :destroy
  
  has_many :relationships
  has_many :followings,    through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers,     through: :reverse_of_relationships, source: :user
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

end
