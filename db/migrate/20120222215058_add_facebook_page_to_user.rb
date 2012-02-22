class AddFacebookPageToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_page, :string
  end

  def self.down
    remove_column :users, :facebook_page
  end
end
