class PicturesController < ApplicationController
  before_filter :authenticate_user!  
  before_filter :setup_user
  before_filter :check_access, :only => [:create, :destroy, :upload_picture, :updte]
  
   
  # GET /pictures
  # GET /pictures.json
  def index    
    @pictures = @user.pictures

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    
    @picture = Picture.find_by_id_and_user_id(params[:id], @user.id)
    
    @facebook = Authorization.where('user_id = ? and provider_id = ?',@user.id, 1000).first
    @twitter  = Authorization.where('user_id = ? and provider_id = ?',@user.id, 2000).first
    @google   = Authorization.where('user_id = ? and provider_id = ?',@user.id, 3000).first
    
    @comments = @picture.comments
    @comments_count = Comment.where(:picture_id => @picture.id, :like => nil).size
    @like_count = Comment.where(:picture_id => @picture.id, :like => true).size
    
    @editable_state = false
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end



  # POST /pictures
  # POST /pictures.json
  def create
    
    unless params[:picture][:avatar1].nil?
      @user.pictures << Picture.new(params[:picture])
      picture = @user.pictures.last
      
      # create activity to upload this picture
      create_activity(current_user.id, "uploaded", "Picture", picture.id) 
      
      redirect_to :action => :index 
    else
      redirect_to :back
    end     
    
  end

 
  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture = Picture.find_by_id_and_user_id(params[:id], @user.id)
    @picture.destroy

    redirect_to :action => :index
     
  end
  
  def upload_picture
    @picture = Picture.new 

  end
  
  def update
    
    if request.xhr?
      puts "this is ajax!!!"
    else
      puts "this is not ajax!!!"
    end
    @picture = Picture.find_by_id_and_user_id(params[:id], @user.id)
    
    @picture.update_attributes(params[:picture])

    redirect_to :action => :show    
  end
  
  private    
  
  def check_access
    puts "check access!!!"
    setup_user
    # @user = User.find(params[:user_id])
    redirect_to :action => :index and return unless @user == current_user
  end  
end
