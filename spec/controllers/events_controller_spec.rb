require 'spec_helper'

describe EventsController do
include Devise::TestHelpers
render_views
  
  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user

    @event = @user.events.create(:title=>"mach", :description=>"match is good", :event_date=>"2012-08-28 14:59:16", :members=>1, :longitude=>51, :latitude=>51)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'all'" do
    it "returns http success" do
      get 'all'
      response.should be_success
    end
  end

  describe "GET 'master'" do
    it "returns http success" do
      get 'master'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @event.id
      response.should be_success
    end
    
   
    
  end


end
