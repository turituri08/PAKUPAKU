class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q, only: [:index, :search]

  def index
    @users = User.all
  end

  def show
    @user        = User.find(params[:id])
    @contents    = Content.where(user_id: [@user]).order(created_at: "DESC")
    @comment_all = Comment.where(content_id: [@content])
    @comment     = Comment.new
    #・DM機能　Entryテーブルからログインしているユーザーとshowページのユーザーを取ってくる
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry        = Entry.where(user_id: @user.id)
    #idが一致しなければroomが作られているか確認し、なければnew、あれば@roomIdにすでに作られているroom_idを入れる
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room  = Room.new
        @entry = Entry.new
      end
    end
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
  
  def user_followings
    @user        = User.find(params[:user_id])
    @users       = @user.followings.order(created_at: "DESC")
  end 
  
  def user_followers
    @user        = User.find(params[:user_id])
    @users       = @user.followers.order(created_at: "DESC")
  end 

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "変更を保存しました"
    else
      redirect_to user_path(@user.id), alert: "変更に失敗しました"
    end
  end
  
  def search
    @results = @q.result
  end

  private
   
  def set_q
    @q = User.ransack(params[:q])
  end

  def user_params
    params.require(:user).permit(:user_name, :profile_image, :introduction, :child_gender, :child_age)
  end
end
