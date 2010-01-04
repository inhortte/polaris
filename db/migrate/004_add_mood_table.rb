class AddMoodTable < ActiveRecord::Migration
  def self.up
    create_table :moods do |table|
      table.column :mood, :string, :null => false
    end
  end

  def self.down
    drop_table :moods
  end
end
