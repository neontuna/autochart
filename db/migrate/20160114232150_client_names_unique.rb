class ClientNamesUnique < ActiveRecord::Migration
  def change
    change_column :clients, :name, :string, null: false, unique: true
  end
end
