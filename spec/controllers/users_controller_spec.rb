require 'spec_helper'

describe UsersController do
include Devise::TestHelpers

describe "access control" do

    it "should require signin to any action" do
      get :index
      response.should redirect_to(new_user_session_path)
      get :show, :id => 1
      response.should redirect_to(new_user_session_path)
      post :search
      response.should redirect_to(new_user_session_path)
      get :index_search
      response.should redirect_to(new_user_session_path)
      get :email_index_search
      response.should redirect_to(new_user_session_path)
    end
end


describe "for signed-in-users" do

  before (:each) do
    @user = FactoryGirl.create(:user)
    @second = FactoryGirl.create(:user)
    @last=FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns all users as @users" do
      get :index
      assigns[:users].should include(@user)
      assigns[:users].should include(@second)
      assigns[:users].should include(@last)
    end
  end

describe "search actons" do
  before (:each) do
    @attr = {
      :email => "edik@example.com",
      :password => "foobar",
      :password_confirmation => "foobar",
      :first_name => "Edik",
      :last_name => "Gataullin",
    }
   @search_user=User.create(@attr)  
  end


  it "should find right user by last name" do
    get :index_search, :term =>'Gataullin'
    assigns[:users].should include(@search_user)
    assigns[:users].should_not include(@user)
  end

  it "should find right user by email" do
    get :email_index_search, :term =>'edik'
    assigns[:users].should include(@search_user)
    assigns[:users].should_not include(@user)
  end

  it "should redirect to user path after press search" do
    post :search, :Search => {:title123=>'Gataullin'}
    response.should redirect_to(user_path(@search_user))
  end


end

end
end

