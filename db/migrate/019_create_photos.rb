class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :user_id, :integer, :null => false
      t.column :thumbnail, :string
      t.column :photo, :string, :null => false
      t.column :title, :string
      t.column :description, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :photos
  end
end
