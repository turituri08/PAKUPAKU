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

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def content_params
    params.require(:content).permit(:body, :target_age, content_images_images: [])
  end
end
