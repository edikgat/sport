class UsersController < ApplicationController
  before_filter :authenticate_user!#, :except => [:show, :index]
  def index
    @users = User.all.paginate(:page => params[:page])
    #@users = User.all
   puts params
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end

  end

  def search
   Rails.logger.info "__________________search_____________________#{params.inspect}"
   # Rails.logger.info "__________________search_events_____________________#{params[:Search][:title123].inspect}"
   if @user=User.find_by_last_name(params[:Search][:title123])
   redirect_to @user
   else
    redirect_to users_path
  end
  end




 def index_search
  Rails.logger.info "__________________index_search_____________________#{params.inspect}"
    @users = User.order(:last_name).where("last_name like ?", "%#{params[:term]}%")
    #params[:id]=10;
    render json: @users.map(&:last_name)
   #Rails.logger.info "__________________search_events_____________________#{params.inspect}"
  end

  def email_index_search
  Rails.logger.info "__________________email_index_search_____________________#{params.inspect}"
    @users = User.order(:email).where("email like ?", "%#{params[:term]}%")
    #params[:id]=10;
    render json: @users.map(&:email)
   #Rails.logger.info "__________________search_events_____________________#{params.inspect}"
  end

  #@categories = Category.order(:name).where("name like ?", "%#{params[:term]}%")
  #  render json: @categories.map(&:name)



end
