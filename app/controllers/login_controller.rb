class LoginController < ApplicationController
#  model :user
  before_filter :authorize_admin, :except => [ :index, :login, :logout, :signup ]

  def add_user
    @user = User.new(params[:user])
    if request.post? && @user.save
      flash.now[:notice] = "The bastard, #{@user.login}, now exists."
      @user = User.new
    end
  end

  def delete_user
    User.find(params[:id]).destroy
    @users = User.find(:all).sort { |u1, u2| u1.login <=> u2.login }
  end

  def index
  end

  def signup
    @user = User.new(params[:user])
    if request.post?
      signup_code = check_signup_code(params[:signup_code])
      if !signup_code
	flash.now[:notice] = "Incorrect signup code."
      elsif @user.save
	flash[:notice] = "You, #{@user.login}, now exist."
	signup_code.destroy
	redirect_to :action => :login
      end
    end
  end

  def generate_signup_code
    thing = [[48,57],[65,90],[97,122]]
    buttock = []
    code_array = []
    thing.each { |a, b| a.upto(b) { |c| buttock << c.chr } }
    6.times { code_array << buttock[rand(buttock.length)] }
    code = code_array.join('')
    @signup_code = SignupCode.new(params[:signup_code])
    if request.post? && @signup_code.save
      if Notifyer.deliver_signup_code(@signup_code.email, @signup_code.code)
	flash.now[:notice] = "The code '#{@signup_code.code}' has been sent to #{@signup_code.email}."
      else
	flash.now[:notice] = "The code '#{@signup_code.code}' could not be sent, but I saved it in the fucking database anyway, you cunt."
      end
      @signup_code.email = ''
    end
    @signup_code.code = code
  end

  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:login], params[:passwd])
      if user
	user.last_login = Time.now
	user.update_attribute('last_login',Time.now)
	flash[:notice] = 'Logged in.'
	session[:user_id] = user.id
	if params[:from_where] == 'blog'
	  redirect_to :controller => 'blog', :action => :index
        else
	  redirect_to :action => :index
        end
      else
	flash[:notice] = "You fucked up."
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logged out.'
    redirect_to :back
  end

  def list_users
    @users = User.find(:all).sort { |u1, u2| u1.login <=> u2.login }
  end

  private

  def check_signup_code(code)
    return SignupCode.find(:first, :conditions => [ "code = ?", code ])
  end
end
