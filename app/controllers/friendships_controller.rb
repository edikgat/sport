class FriendshipsController < ApplicationController
  before_filter :authenticate_user!#, :except => [:show, :index]
  # GET /friendships
  # GET /friendships.json
  #автризованные друзья==authorized_friends
  def index
    #userss = current_user.my_authorized_friends + current_user.inverse_authorized_friends
    @users=User.friends_wich_accepted(current_user.id).paginate(:page => params[:page])
#gfhghgfgfhgfhgfhgfhfggfgf
   # current_usr.inverse_authorized_friends.each do |friend|
    
   #   @users << friend
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end
#incoming requests
  def incoming
    @users = current_user.inverse_friends.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end
#outgoing requests
  def outgoing
    @users = current_user.unauthorized_friends.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end
  # GET /friendships/1
  # GET /friendships/1.json
  def show
    @friendship = Friendship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/new
  # GET /friendships/new.json
  def new
    redirect_to users_url
    #@friendship = Friendship.new

   # respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @friendship }
    #end
  end

  # GET /friendships/1/edit
  def edit
    @friendship = Friendship.find(params[:id])
  end

  # POST /friendships
  # POST /friendships.json
  def create
     Rails.logger.info "__________________params_____________________#{params.inspect}"  
     @friendship = current_user.friendships.create!(:friend_id=>params[:format])
     redirect_to friendships_url

  end

  
  # PUT /friendships/1
  # PUT /friendships/1.json
  def update
    #@friendship = Friendship.find(params[:id])
     #Rails.logger.info "__________________params[:id]_____________________#{params[:id].inspect}"  
    #Rails.logger.info "__________________params[:id]_____________________#{current_user.id).inspect}" 
    @friendship = Friendship.find_by_user_id_and_friend_id(params[:id],current_user.id)
     # Rails.logger.info "__________________friendship___________________#{friendship.inspect}" 

    respond_to do |format|
      if @friendship.update_attributes(:authorized=>true)
        format.html { redirect_to incoming_requests_path, notice: 'Friendship was successfully authorized.' }
        format.json { head :no_content }
      else
        format.html { redirect_to incoming_requests_path }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy


    if @friendship = Friendship.find_by_user_id_and_friend_id(current_user.id, params[:id])
    @friendship.destroy
  else
    if @friendship = Friendship.find_by_user_id_and_friend_id(params[:id], current_user.id)
    @friendship.destroy
    end
  end

    respond_to do |format|
     format.html { redirect_to friendships_url }
      format.json { head :no_content }
    end
  end
end
