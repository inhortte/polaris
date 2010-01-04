class AddGoodFlagToHaikus < ActiveRecord::Migration
  def self.up
    add_column :haikus, :good_flag, :boolean, :default => false
  end

  def self.down
    remove_column :haikus, :good_flag
  end
end
