# == Schema Information
# Schema version: 13
#
# Table name: moods
#
#  id   :integer(11)   not null, primary key
#  mood :string(255)   default(), not null
#

class Mood < ActiveRecord::Base
  has_many :entries,
           :dependent => :nullify
end
