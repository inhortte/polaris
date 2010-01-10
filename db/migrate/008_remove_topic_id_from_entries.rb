class RemoveTopicIdFromEntries < ActiveRecord::Migration
  def self.up
    remove_column :entries, :topic_id
  end

  def self.down
    add_column :entries, :topic_id, :integer, :null => false
  end
end
