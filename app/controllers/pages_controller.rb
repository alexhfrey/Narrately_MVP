class PagesController < ApplicationController
  def home
  if (current_user) 
	redirect_to current_user 
  end
  end
  def connect
  if (current_user) 
	redirect_to "projects#new"
  end
end
end
