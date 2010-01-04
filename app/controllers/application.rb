# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

# require_dependency "login_system"

class ApplicationController < ActionController::Base
#  include LoginSystem
#  model :user

  private

  def authorize
    unless session[:user_id]
      session[:original_uri] = request.request_uri
      flash[:notice] = 'You gotta log in.'
      c, a = redir(request.request_uri)
      redirect_to :controller => c, :action => a
      return false
    end
    return true
  end

  def authorize_admin
    if authorize
      unless User.find(session[:user_id]).admin_flag == 1
	flash[:notice] = 'You are not allowed there, vole.'
	redirect_to :controller => 'login', :action => :index
      end      
    end
  end

  def redir(uri)
    if uri =~ /blog/
      return [ 'blog', :index ]
    else
      return [ 'login', :login ]
    end
  end
end
