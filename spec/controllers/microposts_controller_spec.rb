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

  
  end

describe "search actons" do
 before(:each) do
    @attr = {
       :content => "new micropost"
       }
       @attr1= {
       :content => "badminton"
       }
      
       @micropost=@user.microposts.create(@attr)
       @micropost1=@user.microposts.create(@attr1)
  end


  it "should redirect to micropost path after press search" do
    post :search, :Search => {:titlemicro =>'badminton'}
    response.should redirect_to(micropost_path(@micropost1))
  end
end

end
end