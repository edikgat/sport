require 'spec_helper'

describe MessagesController do
include Devise::TestHelpers
render_views
describe "access control" do

    it "should require signin to any action" do
      get :index
      response.should redirect_to(new_user_session_path)
      get :reverse
      response.should redirect_to(new_user_session_path)
      get :chat_index
      response.should redirect_to(new_user_session_path)
      get :new
      response.should redirect_to(new_user_session_path)
      get :chat_show, :id => 1
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
    @friend= FactoryGirl.create(:user)
    @attr= {
       :content => " Hellow! ",
       :receiver_id => @friend.id
       }
    @attr_user= {
       :content => " Hellow! ",
       :receiver_id => @user.id
       }
       @message=@user.messages.create(@attr)
  end

describe "index style of actions" do  
     

     before (:each) do 
     @other_user=FactoryGirl.create(:user)
     @user_message_for_friend=@user.messages.create(@attr)
     @friend_message_for_user=@friend.messages.create(@attr_user)
     @other_user_message_for_friend=@other_user.messages.create(@attr)
     @user_message_for_other_user=@user.messages.create(:content=>"Hi", :receiver_id=>@other_user.id)
     end

  


  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

     it "assigns all user outgoing messages as @messages" do
      get :index
      assigns[:messages].should include(@user_message_for_friend)
      assigns[:messages].should_not include(@friend_message_for_user)
      assigns[:messages].should_not include(@other_user_message_for_friend)
      assigns[:messages].should include(@user_message_for_other_user)
    end

  end

  describe "GET 'reverse'" do
    it "returns http success" do
      get 'reverse'
      response.should be_success
    end

      it "assigns all user reverse messages as @messages" do
      get :reverse
      assigns[:messages].should_not include(@user_message_for_friend)
      assigns[:messages].should include(@friend_message_for_user)
      assigns[:messages].should_not include(@other_user_message_for_friend)
      assigns[:messages].should_not include(@user_message_for_other_user)
    end
  end

  describe "GET 'chat_index'" do

      before (:each) do 
    
     @new_user_message_for_friend=@user.messages.create(@attr)
     end

    it "returns http success" do
      get 'chat_index'
      response.should be_success
    end

      it "assigns all chats as @messages" do
      get :chat_index
      assigns[:messages].should_not include(@user_message_for_friend)
      assigns[:messages].should_not include(@friend_message_for_user)
      assigns[:messages].should_not include(@other_user_message_for_friend)
      assigns[:messages].should include(@user_message_for_other_user)
      assigns[:messages].should include(@new_user_message_for_friend)
    end 
  end

   describe "GET 'chat_show'" do
    it "should be successful" do
      get :chat_show, :id => @friend.id
      response.should be_success
    end
    it "should find the right chat" do
      get :chat_show, :id => @friend.id
      assigns[:messages].should include(@user_message_for_friend)
      assigns[:messages].should include(@friend_message_for_user)

    end 
  end




end

 describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @message.id
      response.should be_success
    end
    it "should find the right event" do
      get :show, :id => @message
      assigns(:message).should == @message
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
        @attr = {:receiver_email => " ", :content => " "}
      end
      
      it "should render the 'new' page" do
        post :create, :Message_to_user => @attr
        response.should redirect_to(new_message_path)
      end

      it "should not create a event" do
        lambda do
          post :create, :Message_to_user => @attr
        end.should_not change(Message, :count)
      end
    end

    describe "success" do
      before(:each) do
        @attr =  {:receiver_email => @friend.email, :content => "Hi friend!"} 
      end

      it "should create a event" do
        lambda do
          post :create, :Message_to_user => @attr
        end.should change(Message, :count).by(1)
      end
      
      it "should redirect to the message show page" do
        post :create, :Message_to_user => @attr
        response.should redirect_to(message_path(assigns(:message)))
      end

    end
  end
  
   describe "GET 'edit'" do

    it "should be successful" do
      get :edit, :id => @message
      response.should be_success
    end
    
  end

   describe "PUT 'update'" do
    

    describe "failure" do
      
      before(:each) do
        @attr = { :content => "", :receiver_id => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @message, :message => @attr
        response.should render_template('edit')
      end
     
    end

    describe "success" do

      before(:each) do
        @attr1 = { :content => "Hi HI", :receiver_id => @friend.id }
      end
      

      it "should change the event's attributes" do
        put :update, :id => @message, :message => @attr1
        @message.reload
        @message.content.should == @attr1[:content]
        @message.receiver_id.should == @attr[:receiver_id]
      end

    end
  end


    describe "DELETE 'destroy'" do
  
        before(:each) do
          @message_destroy=@user.messages.create(@attr)
        end
      
      it "should destroy the micropost" do
        lambda do
          delete :destroy, :id => @message_destroy
         # flash[:success].should =~ /deleted/i
          response.should redirect_to(messages_path)
        end.should change(Message, :count).by(-1)
      end
    end


 end
end