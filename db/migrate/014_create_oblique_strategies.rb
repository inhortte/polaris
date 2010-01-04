class CreateObliqueStrategies < ActiveRecord::Migration
  def self.up
    create_table :oblique_strategies do |t|
      t.column :oblique_strategy, :string, :null => false
    end
  end

  def self.down
    drop_table :oblique_strategies
  end
end
