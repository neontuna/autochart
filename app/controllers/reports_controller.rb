class ReportsController < ApplicationController

  def show
    if @client = Client.find_by_id(params[:client_id])
      @tickets = @client.sorted_tickets( params[:date][:month].to_i, 
                                         params[:date][:year].to_i )
      @totals = @client.category_totals( params[:date][:month].to_i, 
                                         params[:date][:year].to_i )
    else
      flash[:warning] = "Invalid Client"
      redirect_to report_home_path
    end
  end


  def index
    @totals_this_year = IssueType.yearly_totals(Date.today.year)
    @totals_last_year = IssueType.yearly_totals(1.year.ago.year)
  end


end
