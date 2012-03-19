class AddBrandNameColumnToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :brand_name, :string
  end

  def self.down
    remove_column :projects, :brand_name
  end
end
