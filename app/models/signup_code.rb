# == Schema Information
# Schema version: 13
#
# Table name: signup_codes
#
#  id    :integer(11)   not null, primary key
#  code  :string(255)   default(), not null
#  email :string(255)   default(), not null
#

class SignupCode < ActiveRecord::Base
  validates_presence_of :code
  validates_uniqueness_of :code
  validates_presence_of :email
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'The fucking email must be formatted well.'

  def validate
    errors.add(:email, 'already pending.') if SignupCode.find(:first, :conditions => [ "email = ?", email ])
  end
end
