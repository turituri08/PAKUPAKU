# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    content = Content.find(params[:content_id])
    favorite = current_user.favorites.new(content_id: content.id)
    favorite.save
    content.create_notification_favorite(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    content = Content.find(params[:content_id])
    favorite = current_user.favorites.find_by(content_id: content.id)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
