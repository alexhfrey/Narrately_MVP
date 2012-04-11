class LeadsController < ApplicationController

before_filter :is_admin, :only => [:show]

def new
@lead = Lead.new
end

def create
@lead = Lead.new(params[:lead])
@lead.save
flash[:success] = "Thanks! You have signed up and we will be in touch."
redirect_to "/"
end

def is_admin
if current_user .nil?
	redirect_to "/" and return
end
if current_user.id == 7
   else
   redirect_to "/" and return
end
		
end

end
