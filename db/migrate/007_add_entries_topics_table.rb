class AddEntriesTopicsTable < ActiveRecord::Migration
  def self.up
    create_table :entries_topics, :id => false do |table|
      table.column :entry_id, :integer, :null => false
      table.column :topic_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :entries_topics
  end
end
