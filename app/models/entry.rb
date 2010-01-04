# == Schema Information
# Schema version: 13
#
# Table name: entries
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   default(0), not null
#  mood_id    :integer(11)   
#  music      :string(255)   
#  subject    :string(255)   
#  entry      :text          default(), not null
#  created_at :datetime      
#  updated_at :datetime      
#

class Entry < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :topics
  has_many :comments,
           :dependent => :delete_all
  belongs_to :mood

#  def destroy
#    self.topics.each { |topic|
#      topic.destroy if topic.entries.length == 1
#    }
#    super.destroy
#  end
end
