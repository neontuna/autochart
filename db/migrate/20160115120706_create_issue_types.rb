class CreateIssueTypes < ActiveRecord::Migration
  def change
    create_table :issue_types do |t|
      t.string :name
      t.integer :autotask_id, null: false, unique: true

      t.timestamps null: false
    end
  end
end
