class CreateLikes < ActiveRecord::Migration
  def self.up
    create_table :likes do |t|
      t.string :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :likes
  end
end
