class CreateSignupCodes < ActiveRecord::Migration
  def self.up
    create_table :signup_codes do |t|
      t.column :code, :string, :null => false
    end
  end

  def self.down
    drop_table :signup_codes
  end
end
