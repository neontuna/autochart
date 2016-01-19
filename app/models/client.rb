class Client < ActiveRecord::Base

  has_many :tickets, primary_key: :autotask_id

  validates_presence_of :name, :autotask_id


  def tickets_for_month(month, year)
    dt = DateTime.new(year, month)
    bom = dt.beginning_of_month
    eom = dt.end_of_month
    tickets.joins(:time_entries).merge( 
      TimeEntry.where("date_worked >= ? AND date_worked <= ?", bom, eom) ).uniq
  end


  def category_totals(month, year)
    totals = Hash.new(0)

    tickets_for_month(month, year).each do |t|
      if t.issue_type
        totals[t.issue_type.name] += t.total_hours(month, year)
      else
        totals["No Category"] += t.total_hours(month, year)
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
