class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.all.paginate(:page => params[:page])
   puts params
    respond_to do |format|
      format.html
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
    end

  end

  def search
   if @user=User.find_by_last_name(params[:Search][:title123])
   redirect_to @user
   else
    redirect_to users_path
  end
  end

  def index_search
    @users = User.order(:last_name).where("last_name like ?", "%#{params[:term]}%")
  end

  def email_index_search
    @users = User.order(:email).where("email like ?", "%#{params[:term]}%")
  end

end
