class AddUserIdToElizees < ActiveRecord::Migration
  def self.up
    add_column :elizees, :user_id, :integer, :null => false
  end

  def self.down
    remove_column :elizees, :user_id
  end
end
