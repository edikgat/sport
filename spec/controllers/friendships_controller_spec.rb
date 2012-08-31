require 'spec_helper'




describe FriendshipsController do
include Devise::TestHelpers
render_views
    
    describe "access control" do
    it "should require signin to any action" do
      get :index
      response.should redirect_to(new_user_session_path)
      get :incoming
      response.should redirect_to(new_user_session_path)
      get :outgoing
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
    end


   
  end
end