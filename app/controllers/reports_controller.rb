class ReportsController < ApplicationController

  def show
    @client = Client.find_by_id(params[:client_id])
    tickets = @client.tickets_for_month(params[:month].to_i, params[:year].to_i)
    @totals = @client.category_totals(tickets)
  end

end
