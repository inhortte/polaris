# == Schema Information
# Schema version: 13
#
# Table name: comments
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   default(0), not null
#  entry_id   :integer(11)   
#  comment_id :integer(11)   
#  subject    :string(255)   
#  comment    :text          default(), not null
#  created_at :datetime      
#  updated_at :datetime      
#

class Comment < ActiveRecord::Base
  acts_as_tree :order => :created_at, :dependent => false
  belongs_to :entry
  belongs_to :user
  attr_accessor :depth

  # I can't get class variables to work.
  def self.depth_spacing
    return 20
  end
end
