class MembershipController < ApplicationController
  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @memberships }
    end
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
    @membership = Membership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @membership }
    end
  end

  # GET /memberships/new
  # GET /memberships/new.json
  def new
    @membership = Membership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @membership }
    end
  end

  # GET /memberships/1/edit
  def edit
    @membership = Membership.find(params[:id])
  end

  # POST /memberships
  # POST /memberships.json
  def create    
    group = Group.find(params[:group_id])
    user = current_user
    membership = Membership.new
    membership.user = user
    membership.group = group
    membership.member_type = 'member'
    membership.save!
    redirect_to :back
  end

  # PUT /memberships/1
  # PUT /memberships/1.json
  def update
    @membership = Membership.find(params[:id])

    respond_to do |format|
      if @membership.update_attributes(params[:membership])
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render json: @membership }
      else
        format.html { render action: "edit" }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove
    @membership = Membership.find_by_user_id_and_group_id(params[:format], params[:group_id])    
    @membership.destroy  

    redirect_to :back
  end
  
  def add_as_group_leader      
    @membership = Membership.find_by_user_id_and_group_id(params[:format], params[:group_id])
    @membership.member_type = 'leader'
    @membership.save!
    
    redirect_to :back
  end
  
  def remove_from_group_leader      
    @membership = Membership.find_by_user_id_and_group_id(params[:format], params[:group_id])
    @membership.member_type = 'member'
    @membership.save!
    
    redirect_to :back
  end  

  def block_from_group     
    @membership = Membership.find_by_user_id_and_group_id(params[:format], params[:group_id])
    @membership.status = 'blocked'
    @membership.save!
    
    redirect_to :back
  end
end
