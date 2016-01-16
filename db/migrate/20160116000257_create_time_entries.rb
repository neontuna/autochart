class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.decimal :hours_to_bill, precision: 8, scale: 4, null: false
      t.datetime :date_worked, null: false
      t.integer :ticket_id, null: false
      t.integer :autotask_id, null: false

      t.timestamps null: false
    end
    add_index :time_entries, :ticket_id
  end
end
