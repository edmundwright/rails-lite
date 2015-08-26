class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.where(username: params[:user][:username]).first

    if user
      flash[:notice] = "Thanks for signing in!"
      log_in_user!(user)
      redirect_to "/dogs"
    else
      flash.now[:errors] = ["User not found!"]
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to "/dogs"
  end
end
