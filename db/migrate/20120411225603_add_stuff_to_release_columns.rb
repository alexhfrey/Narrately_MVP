class AddStuffToReleaseColumns < ActiveRecord::Migration
  def self.up
    add_column :releases, :description, :text
    add_column :releases, :image, :string
  end

  def self.down
    remove_column :releases, :image
    remove_column :releases, :description
  end
end
