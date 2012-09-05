class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
  
  def index    
    @users = User.friends_wich_accepted(current_user.id).paginate(:page => params[:page])
  end

  def incoming
    @users = current_user.inverse_friends.paginate(:page => params[:page])
  end
  
  def outgoing
    @users = current_user.unauthorized_friends.paginate(:page => params[:page])
  end
 
  def show
    @friendship = Friendship.find(params[:id])
  end

  def new
    redirect_to users_url
  end

  def edit
    @friendship = Friendship.find(params[:id])
  end
  
  def create
    if current_user.can_add_to_friends?(User.find(params[:format]))
      @friendship = current_user.friendships.build(:friend_id => params[:format])
      
      if @friendship.save
        flash[:notice] = 'Added to friends!'
        redirect_to outgoing_requests_path
      else 
        flash[:notice] = 'Sorry something wrong!'
        redirect_to users_url
      end
    else  
      flash[:notice] = 'You cant!'
      redirect_to users_url
    end
  end
  

  def update
    @friendship = Friendship.find_by_user_id_and_friend_id(params[:id],current_user.id)
    
    if @friendship.present?
      @friendship.update_attributes(:authorized => true)
      
      redirect_to incoming_requests_path, notice: 'Friendship was successfully authorized.'
    else
      flash[:error] = 'Something wrong!'
      redirect_to incoming_requests_path    
    end
  end

  def destroy
    @friendship = Friendship.my_friends(current_user.id, params[:id]).first
    @friendship.destroy
    
    redirect_to friendships_url
  end
end
