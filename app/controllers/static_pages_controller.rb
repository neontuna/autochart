class StaticPagesController < ApplicationController

  skip_before_action :require_sign_in, only: [:welcome]

  def welcome
    
  end

end
