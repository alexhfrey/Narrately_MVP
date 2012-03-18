class LikesController < ApplicationController
  def new
  @project = Project.find(params[:project_id])
  @like = @project.likes.build
  end

  def create
  @project = Project.find(params[:project_id])
  @like = @project.likes.build(params[:like])
  end

end
