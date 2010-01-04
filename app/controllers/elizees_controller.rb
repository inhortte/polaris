require 'fileutils'

class ElizeesController < ApplicationController
  before_filter :authorize

  def index
    Elizee.scan_photos_dir
    @elizee_pages, @elizees = paginate :elizees, :order => 'created_at desc', :per_page => 14

    respond_to { |format|
      format.html {
	render :html => 'index.html'
      }
      format.xml {
	render :xml => @elizees.to_xml
      }
    }
  end

  def show
    redirect_to elizees_url
  end

  def new
    @elizee = Elizee.new
    @elizee.file = ''
  end

  def edit
    @elizee = Elizee.find(params[:id])
  end

  def create
    errors = [ ]
    if params[:file_upload].nil?
      errors += [ 'The file upload was nil.' ]
    elsif params[:file_upload].class.to_s == 'StringIO'
      errors += [ 'A StringIO object was returned. IE, the upload field was left blank.' ]
    elsif !File.exists?(params[:file_upload].path)
      errors += [ 'An error occured in uploading the file (it does not exist on the server).' ]
    end
    if errors.length == 0
      photos_path = 'public/' + PHOTOS_PATH + 'photos/'
      FileUtils.mv(params[:file_upload].path, photos_path + params[:file])
#      File.rename(params[:file_upload].path, photos_path + params[:file])
      elizee = Elizee.new
      elizee.populate(params[:file], params[:user_id])
      redirect_to elizees_url
    else
      flash[:notice] = errors.join('<br />')
      redirect_to new_elizee_url
    end
  end

  def destroy
    photos_path =     photos_path = 'public/' + PHOTOS_PATH
    elizee = Elizee.find(params[:id])
    file = elizee.file
    elizee.destroy

    if File.exists?(photos_path + 'photos/' + file)
      File.unlink(photos_path + 'photos/' + file,
		  photos_path + 'web_photos/' + file,
		  photos_path + 'thumbnails/' + file)
    end
    redirect_to elizees_url
  end

  def parse_filename
    logger.debug "\nTHURK!\n" + params[:filename] + "\n"
    unless params[:filename].blank?
      @elizee.file = params[:filename].split('/').last
      render :partial => 'file_name_field', :layout => false, :locals => { :name => @elizee.file }
    end
  end

  private
  
end
