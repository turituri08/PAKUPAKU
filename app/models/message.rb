# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many   :notifications, dependent: :destroy

  validates  :message, presence: true

  def create_notification_message(current_user, room, message)
    @roommembernotme = Entry.where(room_id: room.id).where.not(user_id: current_user.id)
    @theid = @roommembernotme.find_by(room_id: room.id)
    notification = current_user.active_notifications.new(
      room_id: room.id,
      message_id: message.id,
      visited_id: @theid.user_id,
      visitor_id: current_user.id,
      action: 'message'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
