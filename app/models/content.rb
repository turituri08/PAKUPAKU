# frozen_string_literal: true

class Content < ApplicationRecord
  validates  :user_id,    presence: true
  validates  :body,       presence: true
  validates  :target_age, presence: true

  belongs_to :user
  belongs_to :category
  has_many   :content_images, dependent: :destroy
  accepts_attachments_for :content_images, attachment: :image
  has_many   :comments,       dependent: :destroy
  has_many   :likes,          dependent: :destroy
  has_many   :favorites,      dependent: :destroy
  has_many   :notifications,  dependent: :destroy

  # user_idが存在する確認
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # いいね通知
  def create_notification_like(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(['visitor_id = ? and visited_id = ? and content_id = ? and action = ? ', current_user.id,
                               user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        content_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      notification.checked = true if notification.visitor_id == notification.visited_id
      # バリデーションが実行された結果、エラーが無い場合trueを返し，エラーが発生した場合falseを返す
      notification.save if notification.valid?
    end
  end

  # お気に入り通知
  def create_notification_favorite(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and content_id = ? and action = ? ', current_user.id,
                               user_id, id, 'favorite'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        content_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      notification.checked = true if notification.visitor_id == notification.visited_id
      notification.save if notification.valid?
    end
  end

  # コメント通知
  def create_notification_comment(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(content_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      content_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
