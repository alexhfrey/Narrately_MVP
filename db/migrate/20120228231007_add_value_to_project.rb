class AddValueToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :promotion_value, :float
  end

  def self.down
    remove_column :projects, :promotion_value
  end
end
