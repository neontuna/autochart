require "autotask_api"

class AutotaskQuery

  def initialize  
    @autotask_account_owner = Rails.application.secrets.autotask_account_owner
    @client = AutotaskAPI::Client.new do |c|
      c.basic_auth = [ Rails.application.secrets.autotask_user,
                       Rails.application.secrets.autotask_password ]
      c.wsdl = Rails.application.secrets.autotask_wsdl
      c.log = true
    end
  end

  
  def query(entity, field, expression)
    AutotaskAPI::QueryXML.new do |query|
      query.entity = entity
      query.field = field
      query.expression = expression
    end
  end


  def accounts_by_owner
    @client.query = query('account', 'ownerresourceid', @autotask_account_owner)
    @client.response.body[:query_response][:query_result][:entity_results][:entity]
  end

end
