class LikesController < ApplicationController
  def create
    content = Content.find(params[:content_id])
    like = current_user.likes.new(content_id: content.id)
    like.save
    redirect_back(fallback_location: root_path)
  end 
  
  def destroy
    content = Content.find(params[:content_id])
    like = current_user.likes.find_by(content_id: content.id)
    like.destroy
    redirect_back(fallback_location: root_path)
  end 
end
