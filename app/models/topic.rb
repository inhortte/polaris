# == Schema Information
# Schema version: 13
#
# Table name: topics
#
#  id    :integer(11)   not null, primary key
#  topic :string(255)   default(), not null
#

class Topic < ActiveRecord::Base
  has_and_belongs_to_many :entries
end
