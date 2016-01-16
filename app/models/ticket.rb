class Ticket < ActiveRecord::Base

  belongs_to :issue_type, primary_key: :autotask_id
  has_many :time_entries

  validates_presence_of :title, :autotask_id, :client_id, :issue_type_id


  # Pull in tickets from Autotask
  def self.update_from_autotask(client_id, month, year)
    ticket_count = Ticket.count
    results = AutotaskQuery.new.tickets_by_account_and_month(client_id, month, year)
    results.each do |t|
      t = Ticket.new(title: t[:title], autotask_id: t[:id], 
                     client_id: t[:account_id], issue_type_id: t[:issue_type])
      Rails.logger.debug {"Adding/updating: #{t.autotask_id}-#{t.title}"}
      t.save
    end
    Rails.logger.debug {"Added #{Ticket.count - ticket_count} new tickets"}
  end


  # API updates instead of inserting duplicate clients
  def save
    # If this is new record, check for existing and update that instead:
    if new_record? && t = Ticket.where(autotask_id: autotask_id).first
      t.update_attributes title: title, client_id: client_id, 
                          issue_type_id: issue_type_id
      return true # just to comply with Rails conventions          
    else
      # just call super to save this record
      super
    end
  end


end