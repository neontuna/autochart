class Client < ActiveRecord::Base

  has_many :tickets, primary_key: :autotask_id

  validates_presence_of :name, :autotask_id


  def tickets_for_month(month, year)
    dt = DateTime.new(year, month)
    bom = dt.beginning_of_month
    eom = dt.end_of_month
    tickets.where("last_activity >= ? AND last_activity <= ?", bom, eom)
  end


  def category_totals(ticket_collection = nil)
    totals = Hash.new(0)

    if ticket_collection
      ticket_collection.each do |t|
        totals[t.issue_type.name] += t.total_hours
      end
    else
      self.tickets.each do |t|
        totals[t.issue_type.name] += t.total_hours
      end
    end

    totals
  end


  # Pull in clients from Autotask
  def self.update_from_autotask
    client_count = Client.count
    query = AutotaskQuery.new
    query.accounts_by_owner.each do |a|
      c = Client.new(name: a[:account_name], autotask_id: a[:id])
      Rails.logger.debug {"Adding/updating: #{c.autotask_id}-#{c.name}"}
      c.save
    end
    Rails.logger.debug {"Added #{Client.count - client_count} new clients"}
  end


  # API updates instead of inserting duplicate clients
  def save
    # If this is new record, check for existing and update that instead:
    if new_record? && c = Client.where(autotask_id: autotask_id).first
      c.update_attributes name: name
      return true # just to comply with Rails conventions          
    else
      # just call super to save this record
      super
    end
  end

end
