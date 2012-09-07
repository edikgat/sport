class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @users = User.all.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def search
    @user = User.find_by_last_name(params[:Search][:title123])
    
    redirect_to ( @user.present? ? @user : users_path)
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
