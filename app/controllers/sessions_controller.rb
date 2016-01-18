class SessionsController < ApplicationController

  skip_before_action :require_sign_in

  def create
    user = User.find_by_email(session_params[:email])
    if user && user.authenticate(session_params[:password])
      sign_in(user)
      flash[:success] = "Welcome back!"
      redirect_back_or(root_path)
    else
      flash[:danger] = "We couldn't sign you in!"
      redirect_to root_path
    end
  end


  private


  def session_params
    params.permit(:email, :password)
  end

end
