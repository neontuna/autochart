namespace :autotask do

  desc "Update Clients Table from Autotask"
  task clients: [:setup_logger] do
    Client.update_from_autotask 
  end


  desc "Update Issue Types from Autotask"
  task issue_types: [:setup_logger] do
    IssueType.update_from_autotask
  end


  #desc "Update Tickets from Autotask"
  #task tickets: 

end

# Log to STDOUT when running Rake.
task setup_logger: :environment do
  logger           = Logger.new(STDOUT)
  logger.level     = Logger::DEBUG
  Rails.logger     = logger
end