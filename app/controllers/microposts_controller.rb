class MicropostsController < ApplicationController
  before_filter :authenticate_user!
 
  def index
    @microposts = current_user.microposts.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end


  def show
    @micropost = Micropost.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @micropost = Micropost.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    respond_to do |format|
      if @micropost.valid?
        @micropost = current_user.microposts.create(params[:micropost])
        format.html { redirect_to @micropost, notice: 'Micropost was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @micropost = Micropost.find(params[:id])
    respond_to do |format|
      if @micropost.update_attributes(params[:micropost])
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url }
    end
  end


  

  def search
   if @micropost=current_user.microposts.find_by_content(params[:Search][:titlemicro])
   redirect_to @micropost
   else
    redirect_to microposts_path
    end
  end
end
