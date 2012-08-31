require 'spec_helper'

describe EventsController do
include Devise::TestHelpers
render_views


  

describe "access control" do

    it "should require signin to any action" do
      get :index
      response.should redirect_to(new_user_session_path)
      get :master
      response.should redirect_to(new_user_session_path)
      get :all
      response.should redirect_to(new_user_session_path)
      get :new
      response.should redirect_to(new_user_session_path)
      get :joined
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
      post :join, :event_id => 1 
      response.should redirect_to(new_user_session_path)
      post :search
      response.should redirect_to(new_user_session_path)
      get :index_search
      response.should redirect_to(new_user_session_path)
    end
end

describe "for signed-in-users" do
  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user

    @event = @user.events.create(:title=>"mach", :description=>"match is good", :event_date=>"2012-08-28 14:59:16", :members=>1, :longitude=>51, :latitude=>51)
  end
  
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end


  end

  describe "GET 'all'" do
    it "returns http success" do
      get 'all'
      response.should be_success
    end
  end

  describe "GET 'master'" do
    it "returns http success" do
      get 'master'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @event.id
      response.should be_success
    end 
  end


describe "search actons" do
 before(:each) do
    @attr = {
       :title => "new event",
       :description => "event is event",
       :members => 1,
       :event_date => "2012-08-28 14:59:16",
       :latitude => 50,
       :longitude => 51
       }
       @attr1= {
       :title => "badminton",
       :description => "event is event",
       :members => 1,
       :event_date => "2012-08-28 14:59:20",
       :latitude => 50,
       :longitude => 51
       }
      
       @event2=@user.events.create(@attr)
       @event1=@user.events.create(@attr1)
  end


  it "should find right event by name" do
    get :index_search, :term =>'badm'
    assigns[:events].should include(@event1)
  end

  it "should redirect to event path after press search" do
    post :search, :Search => {:title123=>'badminton'}
    response.should redirect_to(event_path(@event1))
  end
end





 end
end