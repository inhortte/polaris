class RemoveThumbnailFromPhotos < ActiveRecord::Migration
  def self.up
    remove_column :photos, :thumbnail
  end

  def self.down
    add_column :photos, :thumbnail, :string
  end
end
