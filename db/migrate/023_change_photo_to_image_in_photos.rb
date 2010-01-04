class ChangePhotoToImageInPhotos < ActiveRecord::Migration
  def self.up
    remove_column :photos, :photo
    add_column :photos, :elizee_id, :integer
  end

  def self.down
    remove_column :photos, :elizee_id
    add_column :photos, :photo, :string, :null => false
  end
end
