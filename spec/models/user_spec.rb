require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar",
      :first_name => "Example",
      :last_name => "User",

    }
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

 
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

    describe "micropost associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @mp1 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
    
    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp1, @mp2]
    end
    
    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        lambda do
          Micropost.find(micropost)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "friendships" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      @friend = FactoryGirl.create(:user)
      @friend1 = FactoryGirl.create(:user)
    end
    
    it "should have a friendships method" do
      @user.should respond_to(:friendships)
    end

    it "should have a my_authorized_friends method" do
      @user.should respond_to(:my_authorized_friends)
    end
    
    it "should have a inverse_authorized_friends method" do
      @user.should respond_to(:inverse_authorized_friends)
    end

    it "should have a unauthorized_friends method" do
      @user.should respond_to(:unauthorized_friends)
    end

    it "should have a friends" do
      @user.should respond_to(:friends)
    end
    
    
    it "should include the another user in the friends array" do
      @user.add_to_friends!(@friend)
      @user.friends.should include(@friend)
    end

    it "should include the reverse_friendships in the inverse_friends array" do
      @friend1.add_to_friends!(@user)
      @user.inverse_friends.should include(@friend1)
    end
    
    it "should have an can_add_to_friends? method" do
      @user.should respond_to(:can_add_to_friends?)
    end

    it "users should'n be self friend" do
      @user.can_add_to_friends?(@user).should be_false
    end

    it "user could be friend to another user only once" do
      @user.add_to_friends!(@friend)
      @friend.can_add_to_friends?(@user).should be_false
    end
    
  end

  describe "messages" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      @friend = FactoryGirl.create(:user)
      @friend1 = FactoryGirl.create(:user)
      @friend2 = FactoryGirl.create(:user)
      @content="Foo bar?"
      @message=@user.messages.create(:content=> @content, :receiver_id=> @friend.id)
      @reverse_message=@friend.messages.create(:content => @content, :receiver_id=> @user.id)
    end
    
    it "should have a messages method" do
      @user.should respond_to(:messages)
    end
    
    it "should have a reverse messages" do
      @user.should respond_to(:reverse_messages)
    end

    it "should have a senders" do
      @user.should respond_to(:senders)
    end
    
    it "should have a receivers" do
      @user.should respond_to(:receivers)
    end

    it "should have the right messages" do
      @user.messages.should == [@message]
    end

    it "should have the right reverse_messages" do
      @user.reverse_messages.should == [@reverse_message]
    end


    it "should include the right chats" do
      another_message=@friend1.messages.create(:content=>@content, :receiver_id=> @friend.id)
      another_message1=@friend2.messages.create(:content=>@content, :receiver_id=> @user.id)
      @user.all_chats_with_user.should == [another_message1, @reverse_message]
    end

  end

   describe "event" do
    
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
      @another_user = FactoryGirl.create(:user)
      @master_event=@user.events.create(@attr)
      q=UsersEvent.find_by_event_id(@master_event.id)
      q[:role]=true
      q.save
      @event=@another_user.events.create(@attr_with_coordinates)
      @joined_event=@another_user.events.create(@attr)
      @user.users_events.create(:event_id=>@joined_event.id)

    end
    
     it "should have a events method" do
      @user.should respond_to(:events)
    end
    
    it "should have a master_events method" do
      @user.should respond_to(:master_events)
    end

     it "should have a users_events method" do
      @user.should respond_to(:users_events)
    end
    
    it "should have the right master_events" do
      @user.master_events.should == [@master_event]
    end

    it "should have the right events" do
      @user.events.should == [@master_event, @joined_event]
    end

  end
    
end