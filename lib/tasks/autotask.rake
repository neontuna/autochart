namespace :autotask do

  desc "Update Clients Table"
  task clients: [:setup_logger] do
    Client.update_from_autotask 
  end


  desc "Update Issue Types"
  task issue_types: [:setup_logger] do
    IssueType.update_from_autotask
  end


  desc "Update A Client's Last Year of Time Entries"
  task :tickets, [:client_id] => :setup_logger do |t, args|
    13.times do |n|
      month = n.months.ago.month
      year = n.months.ago.year
      Rails.logger.debug { "Tickets from #{month}-#{year}"}
      Ticket.update_from_autotask(args.client_id, month, year)
      sleep(0.2)
    end

    Client.find_by_autotask_id(args.client_id).tickets.each do |ticket|
      TimeEntry.update_from_autotask(ticket.autotask_id)
      sleep(0.2)
    end
  end


  desc "Update ALL Clients time for this and last year"
  task all: [:setup_logger] do
    Client.all.each do |c|
      # Get All Tickets from this year
      Date.today.month.downto(1) do |m|
        Rails.logger.debug { "#{c.name}, tickets from #{m}-#{Date.today.year}"}
        Ticket.update_from_autotask(c.autotask_id, m, Date.today.year)
        sleep(0.2)
      end

      # Get All Tickets from last year
      1.upto(12) do |m|
        Rails.logger.debug { "#{c.name}, tickets from #{m}-#{1.year.ago.year}"}
        Ticket.update_from_autotask(c.autotask_id, m, 1.year.ago.year)
        sleep(0.2)
      end

      if c.tickets.any?
        c.tickets.each do |ticket|
          TimeEntry.update_from_autotask(ticket.autotask_id)
          sleep(0.2)
        end
      end
    end
  end

end

# Log to STDOUT when running Rake.
task setup_logger: :environment do
  logger           = Logger.new(STDOUT)
  logger.level     = Logger::DEBUG
  Rails.logger     = logger
end