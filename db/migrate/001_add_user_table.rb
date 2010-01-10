class AddUserTable < ActiveRecord::Migration
  def self.up
    create_table :users do |table|
      table.column :login, :string
      table.column :password, :string
      table.column :name, :string
      table.column :email, :string
      table.column :created_at, :datetime
      table.column :updated_at, :datetime
      table.column :last_login, :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
