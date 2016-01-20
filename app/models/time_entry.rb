class TimeEntry < ActiveRecord::Base

  belongs_to :ticket, primary_key: :autotask_id


  def self.for_period(start_date, end_date)
    TimeEntry.where("date_worked >= ? AND date_worked <= ?", 
      start_date, end_date)#.sum(:hours_to_bill)
  end


  def self.update_from_autotask(ticket_id)
    time_entries = AutotaskQuery.new.time_entry_by_ticket_id(ticket_id)
    if time_entries
      time_entries.each do |entry|
        e = TimeEntry.new( ticket_id: entry[:ticket_id], autotask_id: entry[:id],
                           hours_to_bill: entry[:hours_worked], 
                           date_worked: entry[:date_worked] )
        e.save 
      end
    end
  end


  # API updates instead of inserting duplicate clients
  def save
    # If this is new record, check for existing and update that instead:
    if new_record? && e = TimeEntry.where(autotask_id: autotask_id).first
      e.update_attributes hours_to_bill: hours_to_bill, 
                          date_worked: date_worked
      Rails.logger.debug { "Updated Time Entry ##{autotask_id}"}
      return true # just to comply with Rails conventions          
    else
      # just call super to save this record
      # Rails.logger.debug { "Added Time Entry ##{autotask_id}"}
      super
    end
  end

end
