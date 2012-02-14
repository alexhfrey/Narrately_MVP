class AddRewardsColumnsToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :promotion_description, :text
    add_column :projects, :promotion_type, :string
  end

  def self.down
    remove_column :projects, :promotion_type
    remove_column :projects, :promotion_description
  end
end
