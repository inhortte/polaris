class PhotoalbumsController < ApplicationController
  before_filter :pa_auth,
    :only => [ :new, :create, :edit, :destroy ]

  # GET /photoalbums
  # session[:pa_parent] will be the current parent photoalbum.
  # its children will be displayed.
  def index
    unless session[:pa_parent]
      session[:pa_parent] = 1
    end
    @photos = Photoalbum.find(session[:pa_parent]).photos

    respond_to { |format|
      format.html {
	render :html => 'index.html'
      }
      format.xml {
	render :xml => @photoalbums.to_xml
      }
    }
  end

  # GET /photoalbums/1
  # Set this photoalbum as the parent and return to the index.
  def show
    session[:pa_parent] = params[:id]

    redirect_to photoalbums_url
  end

  # GET /photoalbums/new
  # Go to the form to create a new photoalbum. Basically, this form
  # just lets one enter the name of the new album. This action should
  # only be available to users who are logged in and are owners of the
  # parent photoalbum (sans photoalbum id #1).
  def new
    @photoalbum = Photoalbum.new
  end

  def edit
    @photoalbum = Photoalbum.find(params[:id])
  end

  # POST /photoalbums
  # Creation is invoked from new.rhtml and is only available to
  # logged in users who own the parent (sans parent # 1).
  def create
    @photoalbum = Photoalbum.new(params[:photoalbum])

    respond_to { |format|
      if @photoalbum.save
	flash[:notice] = "New photoalbum! It's parent is <em>" +
	  Photoalbum.find(session[:pa_parent]).name + "</em>."

	# Go to index.
	format.html { redirect_to photoalbums_url }
	format.xml { head :created, :location => photoalbum_url(@photoalbum) }
      else
	format.html { render :action => 'new' }
	format.xml { render :xml => @photoalbum.errors.to_xml }
      end
    }
  end

  # PUT /photoalbums/1
  def update
    @photoalbum = Photoalbum.find(params[:id])

    respond_to { |format|
      if @photoalbum.update_attributes(params[:photoalbum])
	flash[:notice] = 'Updated.'

	format.html { redirect_to photoalbums_url }
	format.xml { head :ok }
      else
	format.html { render :action => 'edit' }
	format.xml { render :xml => @photoalbum.errors.to_xml }
      end
    }
  end

  # DELETE /photoalbums/1
  def destroy
    @photoalbum = Photoalbum.find(params[:id])
    @photoalbum.destroy

    respond_to { |format|
      format.html { redirect_to photoalbums_url }
      format.xml { head :ok }
    }
  end

  def rearrange
    photo_ids = params[:photo_list]
    photo_ids.each_index { |i|
      photo = Photo.find(photo_ids[i])
      photo.position = i + 1
      photo.save!
    }
    render(:update) do |page|
    end
  end

  private

  def pa_auth
    if authorize
      if authorize_admin || (session[:pa_parent] == 1) ||
	  (Photoalbum.find(session[:pa_parent]).user_id == session[:user_id])
	return true
      end
    end
    return false
  end

end
