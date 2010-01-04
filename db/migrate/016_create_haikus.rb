class CreateHaikus < ActiveRecord::Migration
  def self.up
    create_table :haikus do |t|
      t.column :user_id, :integer, :null => false
      t.column :haiku, :text, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :haikus
  end
end
