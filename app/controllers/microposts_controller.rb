class MicropostsController < ApplicationController
  before_filter :authenticate_user!
 
  def index
    @microposts = current_user.microposts.paginate(page: params[:page])
  end


  def show
    @micropost = Micropost.find(params[:id])
  end

  def new
    @micropost = Micropost.new
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    
    if @micropost.save
      redirect_to @micropost, notice: 'Micropost was successfully created.'
    else
      flash[:error] = 'Wrong'
      render action: "new"
    end
  end

  def update
    @micropost = Micropost.find(params[:id])
    
    if @micropost.update_attributes(params[:micropost])
      redirect_to @micropost, notice: 'Micropost was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    
    redirect_to microposts_url
  end

  def search
    @micropost = current_user.microposts.find_by_content(params[:Search][:titlemicro])

    redirect_to (@micropost.present? ? @micropost :  microposts_path)
  end  
end
