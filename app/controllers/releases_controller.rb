class ReleasesController < ApplicationController
before_filter :owns_project, :only => [:edit, :update, :create, :new, :destroy]
  # GET /releases
  # GET /releases.xml
  def index
    @releases = Release.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @releases }
    end
  end

  # GET /releases/1
  # GET /releases/1.xml
  def show
   @release = Release.find(params[:id])
   @project = Project.find(params[:project_id])
   @user = current_user
	if @user.nil?
		session[:redirect] = request.url
		redirect_to '/auth/facebook' and return
	
	elsif @release.release_shares.collect {|s| s.user } .include?(@user)
		redirect_to @release.content_url and return
	else 	
		@release_share = @release.release_shares.build(:user_id => @user.id)
		@release_share.save
		graph = Koala::Facebook::API.new(@user.token)
		graph.put_wall_post("Just got this for free from mysnowball.com", {:link => "www.mysnowball.com/releases/" + @release.id.to_s })
		redirect_to @release.content_url and return
	end
	
   
  end

  # GET /releases/new
  # GET /releases/new.xml
  def new
	@project = Project.find(params[:project_id])
    @release = @project.releases.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @release }
    end
  end

  def confirmation
  @release = Release.find(params[:id])
  @project = Project.find(params[:project_id])
  end
  
  # GET /releases/1/edit
  def edit
    @release = Release.find(params[:id])
  end

  # POST /releases
  # POST /releases.xml
  def create
    
	@project = Project.find(params[:project_id])
	@release = @project.releases.build(params[:release])
    respond_to do |format|
      if @release.save
        format.html { redirect_to(confirmation_project_release_path(@project, @release), :notice => 'Release was successfully created.') }
        format.xml  { render :xml => @release, :status => :created, :location => @release }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  def share
	@user = current_user
	@project = Project.find(params[:project_id])
	@release = Release.find(params[:id])
	graph = Koala::Facebook::API.new(@user.token)
	graph.put_wall_post("Please check out my new work - it's free to all who share it!", {:link => @release.page })
	flash[:success] = "We posted the details to your wall. Don't forget to share it via email and twitter as well!"
	redirect_to admin_project_path(@project)
  end
  # PUT /releases/1
  # PUT /releases/1.xml
  def update
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attributes(params[:release])
        format.html { redirect_to(@release, :notice => 'Release was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /releases/1
  # DELETE /releases/1.xml
  def destroy
    @release = Release.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to(releases_url) }
      format.xml  { head :ok }
    end
  end
  
   def owns_project
	@user = current_user
	if @user.nil?
		flash[:notice] = "You must sign in to access this page"
		session[:redirect] = request.url
		redirect_to signin_path and return
	end
	@project = Project.find(params[:project_id])
	if @user == @project.user || @user.id == 10 || @user.id == 7

	else
	flash[:error] = "You must be the owner of this project to view this page."
	redirect_to @project
	end
   end
end
