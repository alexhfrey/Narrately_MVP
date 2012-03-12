class FixJamesProject < ActiveRecord::Migration
  def self.up
  p = Project.find(15)
  p.user_id = User.find_by_name("James Altucher").id
  p.save
  end

  def self.down
  end
end
