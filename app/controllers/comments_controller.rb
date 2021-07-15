# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @content = @comment.content
    if @comment.save
      @content.create_notification_comment(current_user, @comment.id)
      redirect_to controller: 'contents', action: 'show', id: @comment.content_id
    else
      redirect_to contents_path
    end
  end

  def destroy
    Comment.find_by(id: params[:id], content_id: params[:content_id]).destroy
    redirect_to content_path(params[:content_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :content_id)
  end
end
