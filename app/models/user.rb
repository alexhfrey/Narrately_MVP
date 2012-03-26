class User < ActiveRecord::Base



has_many :projects
has_many :shares
has_many :action_takens
validates :biography, :length =>  {:maximum => 140}
						
before_create :add_to_mailchimp
						
def first_name
name.split[0]
end

def facebook_page_link
if facebook_page.first(4) != "http"
	if facebook_page.first(3) != "www"
	'http://www.' + facebook_page
	else
	'http://' + facebook_page
	end
else
facebook_page
end
end
	
def add_to_mailchimp
if email.present?
gb = Gibbon.new("d6986d50ea90033e826ab23c38eb1c1b-us4")
gb.listSubscribe(:email_address => self.email, :double_optin => false, :id => '34a1789213',
	:update_existing => true, :replace_interests => false, :send_welcome => true)
else return
end
end
	
def add_to_chimp_backers
if email.present?
gb = Gibbon.new("d6986d50ea90033e826ab23c38eb1c1b-us4")
mergevars = {"Groupings" => [{"name" => 'User type', "groups" => 'Backers'}]}
gb.listSubscribe(:email_address => self.email, :double_optin => false, :id => '34a1789213', :merge_vars => mergevars, :update_existing => true, :replace_interests => false, :send_welcome => true)
else return
end
end

def add_to_chimp_creators
if email.present?
gb = Gibbon.new("d6986d50ea90033e826ab23c38eb1c1b-us4")
mergevars = {"groupings" => [{"name" => 'User type', "groups" => 'Creators'}]}
gb.listSubscribe(:email_address => self.email, :double_optin => false, :id => '34a1789213', :merge_vars => mergevars, :update_existing => true, :replace_interests => false)
else return
end
end
	
def self.create_with_omniauth(auth)
create! do |user|
	user.provider = auth["provider"]
	user.uid = auth["uid"]
	user.name = auth["info"]["name"]
	user.email = auth["info"]["email"]
	user.token = auth['credentials']['token'] #Store token info for later use
	
	
end
end

def profile_large
	if provider == "twitter"
	"/images/facebook_default_big.jpg"
	else
	if uid.present?
	"http://graph.facebook.com/" + uid + "/picture?type=large"
	end
	end
end 

def profile_square 
	if provider == "twitter"
	"/images/facebook_default_square.jpg"
	else
	if uid.present?
		"http://graph.facebook.com/" + uid + "/picture?type=square"
	end
	end
end



end
