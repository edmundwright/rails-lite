class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if user
      flash[:notice] = "Thanks for signing in!"
      log_in_user!(user)
      redirect_to "/"
    else
      flash.now[:errors] = ["Username or password not correct!"]
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to "/"
  end
end
