require 'spec_helper'

describe Message do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)
    @attr = { :content => "lorem ipsum", :receiver_id=> @friend.id }
  end
  
  it "should create a new instance with valid attributes" do
    @user.messages.create!(@attr)
  end
  
  describe "sender and receiver associations" do
    
    before(:each) do
      @message = @user.messages.create(@attr)
    end
    
    it "should have a sender attribute" do
      @message.should respond_to(:sender)
    end

    it "should have a receiver attribute" do
      @message.should respond_to(:receiver)
    end
    
    it "should have the right associated sender" do
      @message.sender_id.should == @user.id
      @message.sender.should == @user
    end

    it "should have the right associated receiver" do
      @message.receiver_id.should == @friend.id
      @message.receiver.should == @friend
    end
  end
  
  describe "validations" do

    it "should have a sender id" do
      Message.new(@attr).should_not be_valid
    end

    it "should have a receiver id" do
      Message.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.messages.build(:content => " ").should_not be_valid
    end
    
  end

  describe "from_users_followed_by" do
    
    before(:each) do
      @other_user = FactoryGirl.create(:user)      
      @user_message = @user.messages.create!(@attr)
      @friend_message = @friend.messages.create!(:content =>"bar", :receiver_id=> @user.id)
      @other_message = @other_user.messages.create!(:content => "baz", :receiver_id=> @friend.id)
      @third_message = @other_user.messages.create!(:content => "baz", :receiver_id=> @user.id)
  
    end
    
    it "should have a all messages with user scope" do
      Message.should respond_to(:all_messages_with_user)
    end

    it "should have a chat_with_friend scope" do
      Message.should respond_to(:chat_with_friend)
    end

    it "all_messages_with_user should include received messages" do
      Message.all_messages_with_user(@user.id).should include(@friend_message)
    end

    it "all_messages_with_user should include messages there user is sender" do
      Message.all_messages_with_user(@user.id).should include(@user_message)
    end

    it "all_messages_with_user should not include other messages" do
      Message.all_messages_with_user(@user.id).should_not include(@other_message)
    end

    it "chat_with_friend should include received friends messages" do
      Message.chat_with_friend(@user.id,@friend.id).should include(@friend_message)
    end
    
    it "chat_with_friend should include users messages to friend" do
      Message.chat_with_friend(@user.id,@friend.id).should include(@user_message)
    end
    
    it "chat_with_friend should not include other messages to user" do
      Message.chat_with_friend(@user.id,@friend.id).should_not include(@third_message)
    end

    it "chat_with_friend should not include any other other messages" do
      Message.chat_with_friend(@user.id,@friend.id).should_not include(@other_message)
    end

  end
end