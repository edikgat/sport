require 'spec_helper'




describe FriendshipsController do
include Devise::TestHelpers
render_views
    
    describe "access control" do
    it "should require signin to any action" do
      get :index
      response.should redirect_to(new_user_session_path)
      get :incoming
      response.should redirect_to(new_user_session_path)
      get :outgoing
      response.should redirect_to(new_user_session_path)
      get :new
      response.should redirect_to(new_user_session_path)
      get :show, :id => 1
      response.should redirect_to(new_user_session_path)
      get :edit, :id => 1
      response.should redirect_to(new_user_session_path)
      put :update, :id => 1
      response.should redirect_to(new_user_session_path)
      post :create
      response.should redirect_to(new_user_session_path)
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
end

    describe "for signed-in-users" do
  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @friend=FactoryGirl.create(:user)
    @friendship=@user.friendships.create(:friend => @friend)
  end

    describe "index stile of actions" do  
     

     before (:each) do 
     @user1=FactoryGirl.create(:user)
     @user2=FactoryGirl.create(:user)
     Friendship.find_by_user_id_and_friend_id(@user.id, @friend.id).update_attributes(:authorized=>true)
     @user.friendships.create(:friend => @user1)
     @user2.friendships.create(:friend => @user)
     @user3=FactoryGirl.create(:user)
     end

  


  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

     it "assigns all user authorized friends as @users" do
      get :index
      assigns[:users].should include(@friend)
      assigns[:users].should_not include(@user1)
      assigns[:users].should_not include(@user2)
      assigns[:users].should_not include(@user3)
    end
  end

  describe "GET 'incoming'" do
    it "returns http success" do
      get 'incoming'
      response.should be_success
    end

      it "assigns  all user incoming friend request's as @users" do
      get :incoming
      assigns[:users].should_not include(@friend)
      assigns[:users].should_not include(@user1)
      assigns[:users].should include(@user2)
      assigns[:users].should_not include(@user3)
    end
  end

  describe "GET 'outgoing'" do
    it "returns http success" do
      get 'outgoing'
      response.should be_success
    end

      it "aassigns  all user outgoing friend request's as @users" do
      get :outgoing
      assigns[:users].should_not include(@friend)
      assigns[:users].should include(@user1)
      assigns[:users].should_not include(@user2)
      assigns[:users].should_not include(@user3)
    end 
  end
end


 describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @friendship.id
      response.should be_success
    end
    it "should find the right event" do
      get :show, :id => @friendship
      assigns(:friendship).should == @friendship
    end 
end
   describe "GET 'new'" do
  
    it "should be successful" do
      get :new
      response.should redirect_to(users_path)
    end
  end


  describe "POST 'create'" do

    describe "failure" do
      
   
      it "should render users page" do
        post :create, :format => " "
        response.should redirect_to ( users_path )
      end

      it "should not create a friendship" do
        lambda do
          post :create, :format => " "
        end.should_not change(Friendship, :count)
      end
    end

    describe "success" do


      before(:each) do
        @new_friend=FactoryGirl.create(:user)
       
      end

      it "should create a friendship" do
        lambda do
          post :create, :format =>@new_friend.id
        end.should change(Friendship, :count).by(1)
      end
      
      it "should redirect to the event show page" do
        post :create, :format => @new_friend.id
        response.should redirect_to ( outgoing_requests_path )
      end

    end
  end

  describe "PUT 'update'" do
    

    describe "failure" do
     

      it "should render the 'edit' page" do
        put :update, :id => " "
        response.should redirect_to incoming_requests_path
      end
     
    end

    describe "success" do

      before(:each) do
        @new_friend=FactoryGirl.create(:user)
      end
      
      it "should change the event's attributes" do
        put :update, :id => @new_friend.id
        response.should redirect_to incoming_requests_path
      end

    end
  end


  describe "DELETE 'destroy'" do
  before(:each) do
        @new_user=FactoryGirl.create(:user)
        @frienship1=@user.friendships.create( :friend_id=> @new_user.id )

      end
      
      it "should destroy the friendship" do
        lambda do
          delete :destroy, :id => @new_user.id
         # flash[:success].should =~ /deleted/i
          response.should redirect_to(friendships_path)
        end.should change(Friendship, :count).by(-1)
      end
    end

   




  end
end