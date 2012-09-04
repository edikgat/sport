require 'spec_helper'

describe MicropostsController do
include Devise::TestHelpers
render_views
describe "access control" do

    it "should require signin to any action" do
      get :index
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
      post :search
      response.should redirect_to(new_user_session_path)
    end
end



describe "for signed-in-users" do
before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @attr = {
       :content => "new micropost"
       }
       @attr1= {
       :content => "badminton"
       }
       @micropost=@user.microposts.create(@attr)
       @micropost1=@user.microposts.create(@attr1)
  
  end

describe "search actons" do


  it "should redirect to micropost path after press search" do
    post :search, :Search => {:titlemicro =>'badminton'}
    response.should redirect_to(micropost_path(@micropost1))
    end
  end

    describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

     it "assigns all microposts events as @microposts" do
      get :index
      assigns[:microposts].should include(@micropost1)
      assigns[:microposts].should include(@micropost)
    end

  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @micropost.id
      response.should be_success
    end
    it "should find the right micropost" do
      get :show, :id => @micropost
      assigns(:micropost).should == @micropost
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
        @attr = { :content => "" }
      end
      
      it "should render the 'new' page" do
        post :create, :event => @attr
        response.should render_template('new')
      end

      it "should not create a event" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do

      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end
      
      it "should redirect to the micropost show page" do
        post :create, :micropost => @attr
        response.should redirect_to(micropost_path(assigns(:micropost)))
      end

    end
  end

   describe "GET 'edit'" do

    it "should be successful" do
      get :edit, :id => @micropost
      response.should be_success
    end
    
  end

  describe "PUT 'update'" do
    

    describe "failure" do
      
      before(:each) do
        @attr = { :content => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @micropost, :micropost => @attr
        response.should render_template('edit')
      end
     
    end

    describe "success" do
      
      it "should change the micropost's attributes" do
        put :update, :id => @micropost, :event => @attr
        @micropost.reload
        @micropost.content.should == @attr[:content]
      end

    end
  end


    describe "DELETE 'destroy'" do
      
      it "should destroy the micropost" do
        lambda do
          delete :destroy, :id => @micropost
         # flash[:success].should =~ /deleted/i
          response.should redirect_to(microposts_path)
        end.should change(Micropost, :count).by(-1)
      end
    end






end
end