class AddDatesToElizees < ActiveRecord::Migration
  def self.up
    add_column :elizees, :created_at, :datetime
    add_column :elizees, :updated_at, :datetime
  end

  def self.down
    remove_column :elizees, :updated_at
    remove_column :elizees, :created_at
  end
end
