# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create destroy]

  def create
    following = current_user.follow(@user)
    if following.save
      @user.create_notification_follow(current_user)
      flash[:success] = 'ユーザーをフォローしました'
    else
      flash.now[:alert] = 'ユーザーのフォローに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    following = current_user.unfollow(@user)
    if following.destroy
      flash[:success] = 'ユーザーのフォローを解除しました'
    else
      flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_user
    @user = User.find(params[:follow_id])
  end
end
