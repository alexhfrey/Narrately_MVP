class CreateFbcomments < ActiveRecord::Migration
  def self.up
    create_table :fbcomments do |t|
      t.string :post_id
      t.string :action_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fbcomments
  end
end
