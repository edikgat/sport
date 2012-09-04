class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.all.paginate(:page => params[:page])
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
<<<<<<< HEAD
   if @user = User.find_by_last_name(params[:Search][:title123])
=======
   if @user=User.find_by_last_name(params[:Search][:title123])
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
      redirect_to @user
   else
      redirect_to users_path
   end
  end

  def index_search
    @users = User.order(:last_name).where("last_name like ?", "%#{params[:term]}%")
    render json: @users.map(&:last_name)
  end

  def email_index_search
    @users = User.order(:email).where("email like ?", "%#{params[:term]}%")
    render json: @users.map(&:email)
  end

end
