class ContentsController < ApplicationController
  
  def new
    @content = Content.new
  end 
  
  def index
  end 
  
  def create 
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
    params.require(:content).permit(:body, {images: []}, :target_age)
  end
end
