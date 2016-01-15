class Client < ActiveRecord::Base

  #validates_uniqueness_of :name, :autotask_id
  validates_presence_of :name, :autotask_id

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
