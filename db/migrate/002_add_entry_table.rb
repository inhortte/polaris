class AddEntryTable < ActiveRecord::Migration
  def self.up
    create_table :entries do |table|
      table.column :user_id, :integer, :null => false
      table.column :topic_id, :integer
      table.column :mood_id, :integer
      table.column :music, :string
      table.column :subject, :string
      table.column :entry, :text, :null => false
      table.column :created_at, :datetime
      table.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :entries
  end
end
