class CreatePhotoalbums < ActiveRecord::Migration
  def self.up
    create_table :photoalbums do |t|
      t.column :user_id, :integer, :null => false
      t.column :parent_id, :integer
      t.column :name, :string, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :photoalbums
  end
end
