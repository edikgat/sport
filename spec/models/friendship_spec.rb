require 'spec_helper'

describe Friendship do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)
    @attr = { :friend_id => @friend.id }
  end
  
  it "should create a new instance with valid attributes" do
    @user.friendships.create!(@attr)  
  end
  
  describe "follow methods" do
    
    before(:each) do
      @friendship = @user.friendships.create!(@attr)  
    end
    
    it "should have a user attribute" do
      @friendship.should respond_to(:user)    
    end
    
    it "should have the right follower" do
      @friendship.user.should == @user
    end

    it "should have a friend attribute" do
      @friendship.should respond_to(:friend)
    end
    
    it "should have the right friend user" do
      @friendship.friend.should == @friend
      
    end
  end

  describe "validations" do
    before(:each) do
      @friendship = @user.friendships.create!(@attr)  
    end
    
    it "should require a user id" do
      Friendship.new(@attr).should_not be_valid
    end
    
    it "should require a friend id" do
      @user.friendships.build.should_not be_valid
    end

    it "should be only one combination of user and friend" do
    @user.friendships.build(@attr).should_not be_valid
    end

    it "should be self friend" do
    @user.friendships.build(:friend_id=> @user.id).should_not be_valid
    end

  end
end