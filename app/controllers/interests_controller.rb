class InterestsController < ApplicationController
  before_filter :authenticate_user!

  def index

    # group by first character of the Interest name
    grouped = Interest.order(:name).group_by{|interest| interest.name[0].upcase}
    
    ## group by # and letter
    @grouped_interests = {}
    
    unless grouped.empty?  
      @grouped_interests["#"] = [] unless grouped.first[0] =~ /[A-Za-z]/
      
      grouped.each do |group|
        unless group[0] =~ /[A-Za-z]/
          @grouped_interests["#"] = @grouped_interests["#"] + group[1]
        else
          @grouped_interests["#{group[0]}"] = group[1]       
        end      
      end
      
      ## find max users and rate
      interests = Interest.all    
      users_arr = []
      interests.each do |interest|
        users_arr << interest.users.size
      end    
      @max_users_count = users_arr.max - 1
      @rate = 50.0/@max_users_count
      ## - end
    end
    ## - end
    

    

  end
  
  def show
    @interest = Interest.find(params[:id])
    @users = @interest.users
  end
  
  def create
    
    user = current_user
    user_interests = user.interests
    
    interests_name = params[:interest].split(',').map(&:strip).map(&:downcase)
    
    ## create a new interest
    interests_name.each do |interest_name|
      
      if user_interests.where('lower(name) = ?', "#{interest_name}").empty?
        new_interest = Interest.new
        new_interest.name = interest_name
        new_interest.save!
        
        related_type = "owner"
        
        user_interest = UserInterest.new
        user_interest.user = user
        user_interest.interest = new_interest
        user_interest.related_type = related_type
        user_interest.save!
        
      end
    end
    ## - end
    
    user_interests.each do |interest|
      unless interests_name.include?(interest.name.downcase)
        user_interest = UserInterest.find_by_user_id_and_interest_id(user.id, interest.id)
        user_interest.destroy
        if interest.users.size == 0
          interest.destroy
        end
      end
    end
    
    
=begin
    user = current_user
    
    interest = Interest.where('lower(name) = ?', "#{params[:interest].downcase}")[0]

    
    if interest.nil?
      puts "new"
      interest = Interest.new
      interest.name = params[:interest].capitalize
      puts "name entered!!!"
      interest.save!
      puts "saved!!!!"
      related_type = "owner"
    else
      puts "already"
      related_type = "member" 
    end
    
    if UserInterest.find_by_user_id_and_interest_id(user.id, interest.id)
      interest = nil
    else

      user_interest = UserInterest.new
      user_interest.user = user
      user_interest.interest = interest
      user_interest.related_type = related_type
      user_interest.save!
         
    end
=end

=begin
      
    respond_to do |format|      
      format.json  { render :json => interest }
    end 
=end
    # redirect_to :controller => :profiles, :action => :show, :user_id => current_user.id

     
    redirect_to :back
  end
  
  def follow
    interest = Interest.find(params[:id])
    user = current_user
    
    user_interest = UserInterest.new
    user_interest.user = user
    user_interest.interest = interest
    user_interest.related_type = "member"
    user_interest.save!
    
    redirect_to :back
  end

  def unfollow
    interest = Interest.find(params[:id])
    user = current_user
    
    user_interest = UserInterest.find_by_user_id_and_interest_id(user.id, interest.id)
    user_interest.destroy
    
      if interest.users.size == 0
        interest.destroy
        redirect_to :action => :index and return
      end
    redirect_to :back
  end
    
  def autocomplete
    first_char = params[:first_char]
    
    interests = Interest.where('lower(name) like ?', "%#{first_char.downcase}%")
        
    
    @interests = []
    interests.each do |interest|
      @interests << interest.name
    end
    
    respond_to do |format|      
      format.json  { render :json => @interests }
    end        
  end  
  
  ## fetch all interests of current user
  def fetch_interests
    
    interests = current_user.interests.select(:name)
    
    respond_to do |format|
      format.json { render :json => interests}
    end
  end


end