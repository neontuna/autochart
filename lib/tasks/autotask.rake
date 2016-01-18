namespace :autotask do

  desc "Update Clients Table from Autotask"
  task clients: [:setup_logger] do
    Client.update_from_autotask 
  end


  desc "Update Issue Types from Autotask"
  task issue_types: [:setup_logger] do
    IssueType.update_from_autotask
  end


  desc "Update Client's Last Year of Time Entries from Autotask"
  task :tickets, [:client_id] => :setup_logger do |t, args|
    13.times do |n|
      month = n.months.ago.month
      year = n.months.ago.year
      Rails.logger.debug { "Tickets from #{month}-#{year}"}
      Ticket.update_from_autotask(args.client_id, month, year)
    end

    Client.find_by_autotask_id(args.client_id).tickets.each do |ticket|
      TimeEntry.update_from_autotask(ticket.autotask_id)
    end
  end

end

# Log to STDOUT when running Rake.
task setup_logger: :environment do
  logger           = Logger.new(STDOUT)
  logger.level     = Logger::DEBUG
  Rails.logger     = logger
end