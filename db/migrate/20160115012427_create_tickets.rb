class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title
      t.integer :issue_type_id
      t.integer :client_id
      t.integer :autotask_id, null: false, unique: true

      t.timestamps null: false
    end
  end
end
