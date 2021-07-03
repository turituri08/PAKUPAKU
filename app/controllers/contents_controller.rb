class ContentsController < ApplicationController

  def new
    @content = Content.new
  end

  def index
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
