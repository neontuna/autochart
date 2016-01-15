class ClientsAutotaskIdNotNull < ActiveRecord::Migration
  def change
    change_column :clients, :autotask_id, :string, null: false, unique: true
  end
end
