class CommentsActAsTrees < ActiveRecord::Migration
  def self.up
    add_column :comments, :parent_id, :integer
#    drop_table :comment_assoc
  end

  def self.down
    remove_column :comments, :parent_id
  end
end
