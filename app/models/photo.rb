class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :photoalbum
  acts_as_list :scope => :photoalbum_id
  has_one :elizee, :dependent => :nullify

  # This should be done in the model of the elizee as an option of 
  # belongs_to, but I don't have my Rails manual here, dammit!
  # Actually, for my own reference, it is an option of has_one,
  # as evidenced above.
#  def destroy
#    self.elizee.photo_id = nil
#    self.elizee.save!
#    super.destroy
#  end
end
