class DogsController < ApplicationController
  def index
    @dogs = Dog.all
    render :index
  end

  def show
    @dog = Dog.find(params[:id])
    render :show
  end

  def new
    @dog = Dog.new
    render :new
  end

  def create
    @dog = Dog.new(dog_params)

    if @dog.save
      flash[:notice] = "Thanks for making a dog!"
      redirect_to "dogs/#{@dog.id}"
    else
      flash.now[:errors] = @dog.errors
      render :new
    end
  end

  private

  def dog_params
    params[:dog]
  end
end
