class CreateElizees < ActiveRecord::Migration
  def self.up
    create_table :elizees do |t|
      t.column :photo_id, :integer
      t.column :file, :string, :null => false
      t.column :width, :integer, :null => false
      t.column :height, :integer, :null => false
      t.column :width_web, :integer, :null => false
      t.column :height_web, :integer, :null => false
      t.column :width_thumb, :integer, :null => false
      t.column :height_thumb, :integer, :null => false
    end
  end

  def self.down
    drop_table :elizees
  end
end
