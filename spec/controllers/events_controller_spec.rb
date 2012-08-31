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
  end

describe "index stile of actions" do  
     

     before (:each) do 
     @event2=@user.events.create(@attr)
     @event1=@user.events.create(@attr1)
     @other_user=FactoryGirl.create(:user)
     @other_user_event=@other_user.events.create(@attr)
     q=UsersEvent.find_by_event_id(@event1.id)
     q[:role]=true
     q.save

     end

  


  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

     it "assigns all user events as @events" do
      get :index
      assigns[:events].should include(@event2)
      assigns[:events].should include(@event1)
      assigns[:events].should include(@event)
      assigns[:events].should_not include(@other_user_event)
    end


  end

  describe "GET 'all'" do
    it "returns http success" do
      get 'all'
      response.should be_success
    end

      it "assigns all user events as @events" do
      get :all
      assigns[:events].should include(@event2)
      assigns[:events].should include(@event1)
      assigns[:events].should include(@event)
      assigns[:events].should include(@other_user_event)
    end
  end

  describe "GET 'master'" do
    it "returns http success" do
      get 'master'
      response.should be_success
    end

      it "assigns all user events as @events" do
      get :master
      assigns[:events].should_not include(@event2)
      assigns[:events].should include(@event1)
      assigns[:events].should_not include(@event)
      assigns[:events].should_not include(@other_user_event)
    end 
  end

  describe "GET 'joined'" do
    it "returns http success" do
      get 'joined'
      response.should be_success
    end

      it "assigns all user events as @events" do
      get :joined
      assigns[:events].should include(@event2)
      assigns[:events].should_not include(@event1)
      assigns[:events].should include(@event)
      assigns[:events].should_not include(@other_user_event)
    end 
  end


end

 describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @event.id
      response.should be_success
    end
    it "should find the right event" do
      get :show, :id => @event
      assigns(:event).should == @event
    end 
end

describe "search actons" do


 before (:each) do 
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

 describe "GET 'new'" do
  
    it "should be successful" do
      get :new
      response.should be_success
    end
  end

   describe "POST 'create'" do

    describe "failure" do
      
      before(:each) do
        @attr = { :title => "", :description => "", :event_date => "",
                  :members => "" }
      end
      
      it "should render the 'new' page" do
        post :create, :event => @attr
        response.should render_template('new')
      end

      it "should not create a event" do
        lambda do
          post :create, :event => @attr
        end.should_not change(Event, :count)
      end
    end

    describe "success" do

      it "should create a event" do
        lambda do
          post :create, :event => @attr
        end.should change(Event, :count).by(1)
      end
      
      it "should redirect to the event show page" do
        post :create, :event => @attr
        response.should redirect_to(event_path(assigns(:event)))
      end

    end
  end
  
   describe "GET 'edit'" do

    it "should be successful" do
      get :edit, :id => @event
      response.should be_success
    end
    
  end

  




 end
end