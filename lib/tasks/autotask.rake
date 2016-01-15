namespace :autotask do

  desc "Update Clients Table from Autotask"
  task update_clients: [:setup_logger] do
    Client.update_from_autotask 
  end

end

# Log to STDOUT when running Rake.
task setup_logger: :environment do
  logger           = Logger.new(STDOUT)
  logger.level     = Logger::DEBUG
  Rails.logger     = logger
end