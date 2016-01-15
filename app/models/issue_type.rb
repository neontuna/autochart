class IssueType < ActiveRecord::Base


  # API updates instead of inserting duplicate clients
  def save
    # If this is new record, check for existing and update that instead:
    if new_record? && t = IssueType.where(autotask_id: autotask_id).first
      t.update_attributes name: name
      return true # just to comply with Rails conventions          
    else
      # just call super to save this record
      super
    end
  end


  # Pull in IssueTypes from Autotask
  def self.update_from_autotask
    results = AutotaskQuery.new.issue_types

    results.each_key do |id|
      t = IssueType.new(name: results[id], autotask_id: id)
      Rails.logger.debug {"Adding/updating: #{t.autotask_id}-#{t.name}"}
      t.save
    end

  end

end
