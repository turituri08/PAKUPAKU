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
end
