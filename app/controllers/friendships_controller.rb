class FriendshipsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  # GET /friendships
  # GET /friendships.json
  #автризованные друзья==authorized_friends
  def index
    @users = current_user.authorized_friends

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end
#incoming requests
  def incoming
    @users = current_user.inverse_friends

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end
#outgoing requests
  def outgoing
    @users = current_user.unauthorized_friends

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
    @friendship = Friendship.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/1/edit
  def edit
    @friendship = Friendship.find(params[:id])
  end

  # POST /friendships
  # POST /friendships.json
  def create
    
     @friendship= current_user.friendships.build(params[:message])

    respond_to do |format|
      if @friendship.valid?
          @friendship= current_user.friendships.create(params[:message])
        format.html { redirect_to @friendship, notice: 'Friendship was successfully created.' }
        format.json { render json: @friendship, status: :created, location: @friendship }
      else
        format.html { render action: "new" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end
  # PUT /friendships/1
  # PUT /friendships/1.json
  def update
    #@friendship = Friendship.find(params[:id])
    @friendship = Friendship.find_by_user_id_and_friend_id(params[:id],current_user.id )

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
