class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      message = Message.create(params.require(:message).permit(:user_id, :message, :room_id).merge(user_id: current_user.id))
      room    = message.room
      message.create_notification_message(current_user, room, message)
      redirect_back(fallback_location: root_path)
    else
      render room_path(message.room_id), alert: "投稿に失敗しました"
    end
  end

end
