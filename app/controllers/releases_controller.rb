class ReleasesController < ApplicationController
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
    @release = Release.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @release }
    end
  end

  # GET /releases/1/edit
  def edit
    @release = Release.find(params[:id])
  end

  # POST /releases
  # POST /releases.xml
  def create
    @release = Release.new(params[:release])

    respond_to do |format|
      if @release.save
        format.html { redirect_to(@release, :notice => 'Release was successfully created.') }
        format.xml  { render :xml => @release, :status => :created, :location => @release }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
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
end
