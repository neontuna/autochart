require 'rails_helper'

describe Client do
  let(:client) { build(:client) }

  describe 'attributes' do
    it 'is valid with a name and autotask_id' do
      expect(client).to be_valid
    end


    it 'is invalid without a name' do
      client.name = ''
      expect(client).not_to be_valid
    end


    it 'is invalid without an autotask_id' do
      client.autotask_id = ''
      expect(client).not_to be_valid
    end
  end


  describe 'find_or_create_by' do
    it 'updates existing records based on autotask_id' do
      client.save
      new_client = build(:client, autotask_id: client.autotask_id,
                                  name: "updated name")
      
      expect { new_client.save }.not_to change(Client, :count)
      client.reload
      expect(client.name).to eq("updated name")
    end
  end
end
