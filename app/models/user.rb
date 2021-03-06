class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  attachment :profile_image

  validates :user_name,    presence: true
  validates :email,        presence: true,
                           uniqueness: true,
                           format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  has_many  :contents,     dependent: :destroy
  has_many  :comments,     dependent: :destroy
  has_many  :likes,        dependent: :destroy
  has_many  :favorites,    dependent: :destroy

  has_many :relationships, dependent: :destroy
  has_many :followings,    through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers,     through: :reverse_of_relationships, source: :user, dependent: :destroy

  has_many :messages,      dependent: :destroy
  has_many :entries,       dependent: :destroy

  # 自分からの通知
  has_many :active_notifications,  class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  
  
  # Likeテーブルにuser_idが存在しているか確認
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  # Favoriteテーブルにuser_idが存在しているか確認
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # もし引数に入ってきたother_userが自分じゃなければ、Relationshipテーブルからfollow_idがother_userのidを取得し、なければ作成する
  def follow(other_user)
    relationships.find_or_create_by(follow_id: other_user.id) unless self == other_user
  end
  
  # もしRelationshipテーブルからフォローを外したいユーザーidが見つかれば、フォローを解除する
  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  # followingsに引数に入ってきたother_userはあるかどうかを返す
  def following?(other_user)
    followings.include?(other_user)
  end
  
  # idだけの部分が何のidを指しているかは、このメソッドを呼び出す部分のuser_id -> @user.create_notification_follow(current_user)　なら@userのid
  # 条件でNotificationテーブルからレコードを探してきて、その条件に合うレコードがなければ、バリデーションチェックして新しく作成
  def create_notification_follow(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
  
  # SNS認証の情報を入れるメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email     = auth.info.email
      user.user_name = auth.info.name
      user.password  = Devise.friendly_token[0, 20]
    end
  end
end
