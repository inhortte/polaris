require 'RMagick'

class Elizee < ActiveRecord::Base
  belongs_to :photo

  PhotosPath = 'public/images/photos/'
  PhotosDir = 'photos/'
  WebPhotosDir = 'web_photos/'
  ThumbsDir = 'thumbnails/'

  # User id must be passed, since the model object cannot access 'session'.
  def Elizee.scan_photos_dir(user_id = 1)
    elizees = [ ]
    Dir.entries(PhotosPath + 'photos').each { |filename|
      unless filename[0] == 46
	# First, see if an Elizee object already exists for this file.
	elizee = self.find(:first, :conditions => [ "file = ?", filename ])
	# If not, create and populate a new Elizee object.
	if elizee.nil?
	  elizee = self.new
	  elizee.populate(filename, user_id)
	end
	elizees += [ elizee ]
      end
    }
    return elizees
  end

  def populate(file, user_id = 1)
    self.file = file
    self.user_id = user_id
    img = Magick::Image.read(PhotosPath + PhotosDir + file).first
    self.width = img.columns
    self.height = img.rows

    if img.rows < WEB_HEIGHT
      self.width_web = img.columns.to_i
      self.height_web = img.rows.to_i
      File.symlink('../' + PhotosDir + file, PhotosPath + WebPhotosDir + file)
    else
      web_width = ((WEB_HEIGHT / img.rows.to_f) * img.columns).to_i
      web = img.resize(web_width, WEB_HEIGHT)
      self.width_web = web_width
      self.height_web = WEB_HEIGHT
      web.write(PhotosPath + WebPhotosDir + file)
    end

    thumb_width= ((THUMB_HEIGHT / img.rows.to_f) * img.columns).to_i
    thumb = img.resize(thumb_width, THUMB_HEIGHT)
    self.width_thumb = thumb_width
    self.height_thumb = THUMB_HEIGHT
    thumb.write(PhotosPath + ThumbsDir + file)

    self.save!
    return self
  end

  # Class method to get all elizees which are not associated with
  # a photo. 'elizee_id' is used to select one which has an associated
  # photo for inclusion (for editing a photo - see photos_controller.rb).
  def self.get_unused_elizees(elizee_id = nil)
   elizees = elizee_id.nil? ? [ ] : [ self.find(elizee_id) ]
    return elizees + self.scan_photos_dir.select { |elizee|
      elizee.photo_id.nil?
    }
  end
end
