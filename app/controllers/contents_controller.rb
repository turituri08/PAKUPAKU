# frozen_string_literal: true

class ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q, only: %i[index search]

  def new
    @content = Content.new
  end

  def index
    contents  = Content.page(params[:page]).per(15)
    @contents = contents.all.order(created_at: 'DESC')
    @comment  = Comment.new
  end

  def index_age0
    contents = Content.where(target_age: '0歳').page(params[:page]).per(15)
    @contents = contents.order(created_at: 'DESC')
    @comment  = Comment.new
  end

  def index_age1
    contents = Content.where(target_age: '1歳').page(params[:page]).per(15)
    @contents = contents.order(created_at: 'DESC')
    @comment  = Comment.new
  end

  def index_age2
    contents = Content.where(target_age: '2歳').page(params[:page]).per(15)
    @contents = contents.order(created_at: 'DESC')
    @comment  = Comment.new
  end

  def index_age3
    contents = Content.where(target_age: '3歳').page(params[:page]).per(15)
    @contents = contents.order(created_at: 'DESC')
    @comment  = Comment.new
  end

  def create
    @content = Content.new(content_params)
    @content.user_id = current_user.id
    if @content.save
      redirect_to contents_path, notice: '投稿しました'
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
      redirect_to content_path(@content.id), notice: '変更を保存しました'
    else
      redirect_to content_path(@content.id), alert: '変更に失敗しました'
    end
  end

  def destroy
    Content.find(params[:id]).destroy
    redirect_to contents_path, notice: '投稿を削除しました'
  end

  def search
    @results = @q.result.page(params[:page]).per(15)
    @comment = Comment.new
  end

  private

  def set_q
    @q = Content.ransack(params[:q])
  end

  def content_params
    params.require(:content).permit(:body, :target_age, content_images_images: [])
  end
end
