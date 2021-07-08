class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user        = User.find(params[:id])
    @contents    = Content.where(user_id: [@user]).order(created_at: "DESC")
    @comment_all = Comment.where(content_id: [@content])
  end

  # ユーザーがいいねした投稿を全て表示
  def user_likes
    @user        = User.find(params[:user_id])
    @contents    = @user.likes.order(created_at: "DESC")
    @comment_all = Comment.where(content_id: [@contents])
  end

  def user_favorites
    @user        = User.find(params[:user_id])
    @contents    = @user.favorites.order(created_at: "DESC")
    @comment_all = Comment.where(content_id: [@contents])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "変更を保存しました"
    else
      redirect_to user_path(@user.id), alert: "変更に失敗しました"
    end
  end

   private

  def user_params
    params.require(:user).permit(:user_name, :profile_image, :introduction, :child_gender, :child_age)
  end
end
