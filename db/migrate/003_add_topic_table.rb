class AddTopicTable < ActiveRecord::Migration
  def self.up
    create_table :topics do |table|
      table.column :topic, :string, :null => false
    end
  end

  def self.down
    drop_table :topics
  end
end
