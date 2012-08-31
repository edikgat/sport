require 'spec_helper'

describe Event do

  before(:each) do
    @attr = {
       :title => "new event",
       :description => "event is event",
       :members => 1,
       :event_date => "2012-08-28 14:59:16",
       }
       @attr_with_coordinates = {
       :title => "new event with with_coordinates",
       :description => "event is event",
       :members => 1,
       :event_date => "2012-08-28 14:59:20",
       :latitude => 50,
       :longitude => 51
       }
       @user = FactoryGirl.create(:user)
  end
  
  it "should create a new instance with valid attributes" do
    @user.events.create!(@attr)
  end
  describe "user associations" do
    
    before(:each) do
      @event = @user.events.create(@attr)   
    end
    
    it "should have a users attribute" do
      @event.should respond_to(:users)
    end
  end

  describe "users_event associations" do
    
    before(:each) do
      @event = @user.events.create(@attr)    
    end
    
    it "should have a users_event attribute" do
      @event.should respond_to(:users_events)
    end
  end

  describe "validations" do

    it "should have a title" do
      event=Event.new(@attr)
      event[:title]=nil
      event.should_not be_valid
    end

    it "should require nonblank title" do
      event=Event.new(@attr)
      event[:title]=" "
      event.should_not be_valid
    end

    it "should reject long title" do
      event=Event.new(@attr)
      event[:title]="a" * 141
      event.should_not be_valid
    end

    it "should have a description" do
      event=Event.new(@attr)
      event[:description]=nil
      event.should_not be_valid
    end

    it "should require nonblank description" do
      event=Event.new(@attr)
      event[:description]=" "
      event.should_not be_valid
    end

    it "should reject long description" do
      event=Event.new(@attr)
      event[:description]="a" * 1501
      event.should_not be_valid
    end

    it "should have a event_date" do
      event=Event.new(@attr)
      event[:event_date]=nil
      event.should_not be_valid
    end

    it "should require nonblank event_date" do
      event=Event.new(@attr)
      event[:event_date]=" "
      event.should_not be_valid
    end

    it "should have a members" do
      event=Event.new(@attr)
      event[:members]=nil
      event.should_not be_valid
    end

    it "should require nonblank members" do
      event=Event.new(@attr)
      event[:members]=" "
      event.should_not be_valid
    end

  end

   describe "with_coordinates" do
    it "should have events with coordinates" do
      event=Event.create(@attr)
      event_with_coordinates=Event.create(@attr_with_coordinates)
      Event.with_coordinates.should == [event_with_coordinates]
    end
   end


end