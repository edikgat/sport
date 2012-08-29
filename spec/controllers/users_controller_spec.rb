require 'spec_helper'

describe UsersController do
include Devise::TestHelpers
render_views

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
  end
#####################
  it "should have the right title" do
  get 'home'
  response.should have_selector("title",
                    :content => "Ruby on Rails Tutorial Sample App | Home")
   end
####################


end
