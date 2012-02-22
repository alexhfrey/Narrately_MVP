class User < ActiveRecord::Base



has_many :projects
has_many :shares
validates :biography, :length =>  {:maximum => 140}
						
before_create :check_email
						
def first_name
name.split[0]
end
	
def add_to_mailchimp
gb = Gibbon.new("d6986d50ea90033e826ab23c38eb1c1b-us4")
gb.listSubscribe(:email_address => self.email, :double_optin => false, :id => '34a1789213',
	:update_existing => true, :replace_interests => false)
end
	
def add_to_chimp_backers
gb = Gibbon.new("d6986d50ea90033e826ab23c38eb1c1b-us4")
mergevars = {:Groupings => [{:Name => 'User type', :groups => 'Backers'}]}
gb.listSubscribe(:email_address => self.email, :double_optin => false, :id => '34a1789213', :merge_vars => mergevars, :update_existing => true, :replace_interests => false)

end

def add_to_chimp_creators
gb = Gibbon.new("d6986d50ea90033e826ab23c38eb1c1b-us4")
mergevars = {:Groupings => [{:Name => 'User type', :groups => 'Creators'}]}
gb.listSubscribe(:email_address => self.email, :double_optin => false, :id => '34a1789213', :merge_vars => mergevars, :update_existing => true, :replace_interests => false)
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

def check_email
if self.email.present?
	self.add_to_mailchimp
end
end
end
