class AddCommentAssocTable < ActiveRecord::Migration
  def self.up
    create_table :comment_assoc, :id => false do |table|
      table.column :parent_id, :integer, :null => false
      table.column :child_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :comment_assoc
  end
end
