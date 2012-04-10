class LeadsController < ApplicationController

def new
@lead = Lead.new
end

def create
@lead = Lead.new(params[:lead])
@lead.save
flash[:success] = "Thanks! You have signed up and we will be in touch."
redirect_to "/"
end
end
