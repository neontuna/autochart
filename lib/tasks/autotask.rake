namespace :autotask do

  desc "Build Clients Table from Autotask"
  task get_clients: [:setup_logger] do
    
    client_count = Client.count
    query = AutotaskQuery.new
    query.accounts_by_owner.each do |a|
      c = Client.new(name: a[:account_name], autotask_id: a[:id])
      puts "Adding/updating: #{c.autotask_id}-#{c.name}"
      c.save
    end
    puts "Added #{Client.count - client_count} new clients"


  end

  # Log to STDOUT when running Rake.
  task setup_logger: :environment do
    logger           = Logger.new(STDOUT)
    logger.level     = Logger::INFO
    Rails.logger     = logger
  end
end
