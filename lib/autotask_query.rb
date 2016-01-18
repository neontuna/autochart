require "autotask_api"

class AutotaskQuery

  def initialize  
    @autotask_account_owner = Rails.application.secrets.autotask_account_owner
    @client = AutotaskAPI::Client.new do |c|
      c.basic_auth = [ Rails.application.secrets.autotask_user,
                       Rails.application.secrets.autotask_password ]
      c.wsdl = Rails.application.secrets.autotask_wsdl
      #c.log = true
    end
  end

  
  def query(entity, field, expression)
    AutotaskAPI::QueryXML.new do |query|
      query.entity = entity
      query.field = field
      query.expression = expression
    end
  end


  def multi_condition_query(entity, conditions)
    AutotaskAPI::QueryXML.new do |query|
      query.entity = entity
      conditions.each do |c|
        query.add_condition(c[:field], c[:op], c[:expression])
      end
    end
  end


  def accounts_by_owner
    @client.query = query('account', 'ownerresourceid', @autotask_account_owner)
    @client.response.body[:query_response][:query_result][:entity_results][:entity]
  end


  def tickets_by_account_id(account_id)
    @client.query = query('ticket', 'accountid', account_id)
    @client.response.body[:query_response][:query_result][:entity_results][:entity]
  end


  def tickets_by_account_and_month(account_id, month, year)
    begin_date = DateTime.new(year, month).strftime('%Y-%m-%dT%H:%M:%S')
    end_date = DateTime.new(year, month).end_of_month.strftime('%Y-%m-%dT%H:%M:%S')

    @client.query = multi_condition_query( 'ticket', 
      [ { field: 'accountid', op: 'equals', expression: account_id },
        { field: 'lastactivitydate', op: 'GreaterThanorEquals', expression: begin_date },
        { field: 'lastactivitydate', op: 'LessThanOrEquals', expression: end_date } ] )
    
    if results = @client.response.body[:query_response][:query_result][:entity_results]
      [results[:entity]].flatten
    end
  end


  def time_entry_by_ticket_id(ticket_id)
    @client.query = query('TimeEntry', 'TicketID', ticket_id)
    
    if results = @client.response.body[:query_response][:query_result][:entity_results]
      [results[:entity]].flatten
    end
  end


  def issue_types
    @client.field_info("Ticket").
      xpath('//AT:Field/AT:Name[text()="IssueType"]/..//AT:PickListValue',
           AT: AutotaskAPI::Client::NAMESPACE).
           inject({}) do |memo, node|
      value, label = node.xpath('(AT:Value | AT:Label)/text()',
                               AT: AutotaskAPI::Client::NAMESPACE).collect(&:to_s)
      memo[value] = label
      memo.reject { |k,v| v=~ /temp/i }
    end
  end

end


##
#4: tt = aq.query('blah', 'foo', 'bar')
#5: tt.add_condition(1,2,3)
#6: tt
# api query defaults to an equal expression
# we just need to reconfigure the query method to take
# additional conditions and add them with our own expression
# Equals
# NotEqual GreaterThan LessThan GreaterThanorEquals LessThanOrEquals BeginsWith
# EndsWith Contains IsNotNull IsNull IsThisDay Like NotLike SoundsLike