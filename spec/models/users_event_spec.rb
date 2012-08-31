require 'spec_helper'

describe Event do

   before(:each) do
     @attr = {
       :title => "new event",
       :description => "event is event",
       :members => 1,
       :event_date => "2012-08-28 14:59:16",
       }
    @user = FactoryGirl.create(:user)
    @event=@user.events.create(@attr)
    @users_event=UsersEvent.find_by_user_id_and_event_id( @user.id, @event.id )
  end

  describe "user associations" do
    
    it "should have a user attribute" do
      @users_event.should respond_to(:user)
    end

    it "should have a event attribute" do
      @users_event.should respond_to(:event)
    end
    
    
    it "should have the right associated user and event" do
      @users_event.user_id.should == @user.id
      @users_event.user.should == @user
      @users_event.event_id.should == @event.id
      @users_event.event.should == @event
    end
  end


  describe "validations" do

    it "should have a user_id" do
      @users_event.update_attributes(:user_id => nil)     
      @users_event.should_not be_valid
    end

    it "should require nonblank :user_id" do
      @users_event.update_attributes(:user_id => " ")     
      @users_event.should_not be_valid

    end

    it "should have a event_id" do
      @users_event.update_attributes(:event_id => nil) 
      @users_event.should_not be_valid
    end

    it "should require nonblank event_id" do
      @users_event.update_attributes(:event_id => " ")    
      @users_event.should_not be_valid
    end


   end


end