class StaticPagesController < ApplicationController

  skip_before_action :require_sign_in, only: [:welcome]
  before_action :redirect_signed_in

  def welcome
    
  end


  private


  def redirect_signed_in
    if signed_in_user?
      redirect_to report_home_path
    end
  end

end
