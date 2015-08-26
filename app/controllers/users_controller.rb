class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Thanks for signing up!"
      log_in_user!(@user)
      redirect_to "dogs"
    else
      flash[:errors] = @user.errors
      render :new
    end
  end

  private

  def user_params
    params[:user]
  end
end
