class AddJames < ActiveRecord::Migration
  def self.up
  User.create :name => 'James Altucher', :email => "james@formulaonecapital.com", :facebook_id =>  "584260635", :twitter_handle => "jaltucher", :profile_image => "https://graph.facebook.com/james.altucher/picture/?type=large", :provider => "facebook", :uid => "584260635" 
  p = Project.find(15)
  p.user_id = User.find_by_name("James Altucher").id
  p.save
  
  end

  def self.down
  end
end
