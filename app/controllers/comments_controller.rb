class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    render :index
  end

  def show
    @comment = Comment.find(params[:id])
    render :show
  end

  def new
    @comment = Comment.new
    render :new
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      flash[:notice] = "Thanks for commenting!"
      redirect_to "comments/#{@comment.id}"
    else
      flash.now[:errors] = @comment.errors
      render :new
    end
  end

  private

  def comment_params
    params[:comment]
  end
end
