class AddPhotoalbumIdToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :photoalbum_id, :integer, :null => false, :after => :user_id
  end

  def self.down
    remove_column :photos, :photoalbum_id
  end
end
