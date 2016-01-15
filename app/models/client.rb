class Client < ActiveRecord::Base

  validates_presence_of :name, :autotask_id


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
    if new_record? && c = Client.where(autotask_id: self.autotask_id).first
      c.update_attributes name: name
      return true # just to comply with Rails conventions          
    else
      # just call super to save this record
      super
    end
  end

end
