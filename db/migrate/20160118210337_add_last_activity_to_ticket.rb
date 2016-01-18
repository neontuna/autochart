class AddLastActivityToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :last_activity, :datetime
  end
end
