class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :user_id
      t.string :project_title
      t.string :project_image
      t.text :description
      t.string :file1
      t.string :file2
      t.string :file3
      t.string :purchase_link
      t.string :tag1
      t.integer :promotion_limit

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
