class AddMediumColumnsToShare < ActiveRecord::Migration
  def self.up
    add_column :shares, :medium, :string
  end

  def self.down
    remove_column :shares, :medium
  end
end
