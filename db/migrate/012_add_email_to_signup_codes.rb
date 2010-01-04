class AddEmailToSignupCodes < ActiveRecord::Migration
  def self.up
    add_column :signup_codes, :email, :string, :null => false
  end

  def self.down
    remove_column :signup_codes, :email
  end
end
