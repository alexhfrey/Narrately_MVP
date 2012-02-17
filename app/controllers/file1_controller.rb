class File1Controller < ApplicationController
  def new
    @uploader = Project.new.file1
    @uploader.success_action_redirect = new_project_url
  end
end