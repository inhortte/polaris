class AddCommentTable < ActiveRecord::Migration
  def self.up
    create_table :comments do |table|
      table.column :user_id, :integer, :null => false
      table.column :entry_id, :integer
      table.column :comment_id, :integer
      table.column :subject, :string
      table.column :comment, :text, :null => false
    end
  end

  def self.down
    drop_table :comments
  end
end
