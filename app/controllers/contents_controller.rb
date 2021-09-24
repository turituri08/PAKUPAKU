# frozen_string_literal: true
include ActionView::Helpers::UrlHelper

class ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q, only: %i[index search]

  def new
    @content = Content.new
  end

  def index
    if request.query_parameters.any?
      index_age(request.query_parameters[:age])
    else
      contents  = Content.page(params[:page]).per(15)
      @contents = contents.all.order(created_at: 'DESC')
      @comment  = Comment.new
    end 
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
    user = Content.find(params[:id]).user
    if current_user == user
      Content.find(params[:id]).destroy
      redirect_to contents_path, notice: '投稿を削除しました'
    end
  end

  def search
    results = @q.result.page(params[:page]).per(15)
    @results = results.all.order(created_at: 'DESC')
    @comment = Comment.new
  end

  private

  def set_q
    @q = Content.ransack(params[:q])
  end

  def content_params
    params.require(:content).permit(:body, :target_age, :category_id, content_images_images: [])
  end
  
  def index_age(age)
    contents = Content.where(target_age: "#{age}歳").page(params[:page]).per(15)
    @contents = contents.order(created_at: 'DESC')
    @comment  = Comment.new
  end 
end
