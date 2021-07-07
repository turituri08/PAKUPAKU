class ContentsController < ApplicationController

  def new
    @content = Content.new
  end

  def index
    @contents = Content.all
    @comment  = Comment.new
  end

  def create
    @content = Content.new(content_params)
    @content.user_id = current_user.id
    if @content.save
      redirect_to contents_path, notice: "投稿しました"
    else
      render new_content_path
    end
  end

  def show
    @content     = Content.find(params[:id])
    @comment     = Comment.new
    @comment_all = Comment.where(content_id: [@content])
  end

  def update
    @content = Content.find(params[:id])
    if @content.update(content_params)
      redirect_to content_path(@content.id), notice: "変更を保存しました"
    else
      redirect_to content_path(@content.id), alert: "変更に失敗しました"
    end 
  end

  def destroy
    Content.find(params[:id]).destroy
    redirect_to contents_path, notice: "投稿を削除しました"
  end

  private

  def content_params
    params.require(:content).permit(:body, :target_age, content_images_images: [])
  end
end
