# == Schema Information
# Schema version: 13
#
# Table name: users
#
#  id         :integer(11)   not null, primary key
#  login      :string(255)   
#  password   :string(255)   
#  name       :string(255)   
#  email      :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#  last_login :datetime      
#  admin_flag :integer(11)   default(0), not null
#

require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  has_many :entries
  has_many :haikus

  def passwd
    @passwd
  end

  def passwd=(pwd)
    @passwd = pwd
    self.password = User.sha1(pwd)
  end

  def self.authenticate(login, pass)
    find(:first, :conditions => ["login = ? AND password = ?", login, sha1(pass)])
  end  

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
    
  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
    
#  before_create :crypt_password
  
#  def crypt_password
#    write_attribute("password", self.class.sha1(password))
#  end

  validates_length_of :login, :within => 3..40
  validates_length_of :passwd, :within => 5..40
  validates_presence_of :login, :passwd, :passwd_confirmation
  validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :passwd, :on => :create     
end
