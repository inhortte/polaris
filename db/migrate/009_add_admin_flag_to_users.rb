class AddAdminFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin_flag, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :admin_flag
  end
end
