class UsersController < ApplicationController
  
  def index
  end 
  
  def show
    @user        = User.find(params[:id])
    @contents    = Content.where(user_id: [@user])
    @comment_all = Comment.where(content_id: [@content])
  end 
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end 
  
   private

  def user_params
    params.require(:user).permit(:user_name, :profile_image, :introduction, :child_gender, :child_age)
  end
end
