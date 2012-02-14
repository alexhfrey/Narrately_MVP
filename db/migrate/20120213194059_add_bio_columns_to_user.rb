class AddBioColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :biography, :text
    add_column :users, :category, :string
  end

  def self.down
    remove_column :users, :category
    remove_column :users, :biography
  end
end
