class Photoalbum < ActiveRecord::Base
  acts_as_tree :order => :name, :dependent => :destroy
  belongs_to :user
  has_many :photos, :order => :position
end
