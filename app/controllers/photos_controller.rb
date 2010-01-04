class PhotosController < ApplicationController
#  layout 'photos', :only => :show
  layout 'photoalbums', :except => :show
  helper PhotoalbumsHelper

  def index
    photoalbum = Photoalbum.find(params[:photoalbum_id])
    @photos = photoalbum.photos.find(:all)

    respond_to { |format|
      format.html { render :html => 'index.html' }
      format.xml { render :xml => @photos.to_xml }
    }
  end

  def show
    @photo = Photo.find(params[:id])

    respond_to { |format|
      format.html { render :html => 'show.html' }
      format.xml { render :xml => @photo.to_xml }
    }
  end

  def new
    @photo = Photo.new
    @elizees = Elizee.get_unused_elizees
  end

  def edit
    @photo = Photo.find(params[:id])
    @elizees = Elizee.get_unused_elizees(@photo.elizee_id)
  end

  # POST /photoalbums/:photoalbum_id/photos
  def create
    @photo = Photo.new(params[:photo])
    @photo.elizee = Elizee.find(params[:photo][:elizee_id])

    respond_to { |format|
      if @photo.save
	flash[:notice] = "The photo <em>" + @photo.title + "</em> has been mummified."

	format.html { redirect_to photoalbum_url(@photo.photoalbum_id) }
	format.xml { head :created, :location => photoalbum_url(@photo.photoalbum_id) }
      else
	format.html { render :action => 'new' }
	format.xml { render :xml => @photo.errors_to_xml }
      end
    }
  end

  # PUT /photoalbums/:photoalbum_id/photos/1
  def update
    @photo = Photo.find(params[:id])
        
    respond_to { |format|
      if @photo.update_attributes(params[:photo])
	@photo.elizee = Elizee.find(@photo.elizee_id)
	flash[:notice] = "Photo updated."
	
	format.html { redirect_to photoalbum_url(@photo.photoalbum_id) }
	format.xml { head :ok }
      else
	format.html { render :action => 'edit' }
	format.xml { render :xml => @photo.errors_to_xml }
      end
    }
  end

  # DELETE /photoalbums/:photoalbum_id/photos/1
  def destroy
    photo = Photo.find(params[:id])
    photo.destroy

    respond_to { |format|
      format.html { redirect_to photoalbum_url(session[:pa_parent]) }
      format.xml { head :ok }
    }
  end

  def download
    @photo = Photo.find(params[:id])
    send_file('public/' + PHOTOS_PATH + "photos/" + @photo.elizee.file,
                :type => 'image/jpeg')
  end

  private

  # @files will be everything from the thumbnails directory sans
  # anything which starts with a dot (hence ascii 46).
  # Moved to the Elizee model, so this code is no longer used.
  def get_elizees(elizee_id = nil)
    elizees = elizee_id.nil? ? [ ] : [ Elizee.find(elizee_id) ]
    return elizees + Elizee.scan_photos_dir.select { |elizee|
      elizee.photo_id.nil?
    }
  end

end
