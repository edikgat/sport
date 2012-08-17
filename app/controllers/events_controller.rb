class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  # GET /events
  # GET /events.json
  #joined_and_master
  def index
    @title="My events"
    @titlesearch


    @events = current_user.events.paginate(:page => params[:page])

    #UsersEvent.all.map {|u| u.delete if u.event.blank? }


##############
   # @categories = Category.order(:name).where("name like ?", "%#{params[:term]}%")
   # render json: @categories.map(&:name)
################


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def search
    Rails.logger.info "__________________search_events_____________________#{params.inspect}"
    Rails.logger.info "__________________search_events_____________________#{params[:Search][:title123].inspect}"
   if @event=Event.find_by_title(params[:Search][:title123])
   redirect_to @event
   else
    redirect_to events_path
  end
  end


  #где я хозяин
  def master
    @title="Events that i create"


    @events = current_user.master_events.paginate(:page => params[:page])
     #Rails.logger.info "__________________users_events_____________________#{users_events.inspect}"  
    #@events = []
    #users_events.each do |user_event|
     # Rails.logger.info "__________________user_event.event__EVENT #{user_event.id}___________________#{user_event.event.inspect}" 
    #  @events << user_event.event
   # end
    #Rails.logger.info "__________________@events_____________________#{@events.inspect}" 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end
  #те куда я пойду
  def joined
    @title="Joined events"


    users_events = current_user.users_events.where(:role => false).paginate(:page => params[:page])
     #Rails.logger.info "__________________users_events_____________________#{users_events.inspect}"  
    @events = []
    users_events.each do |user_event|
     # Rails.logger.info "__________________user_event.event__EVENT #{user_event.id}___________________#{user_event.event.inspect}" 
      @events << user_event.event
    end
    #Rails.logger.info "__________________@events_____________________#{@events.inspect}" 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  
  #все
  def all
    @title="All events"


    @events = Event.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @width=500
    @latitude=@event.latitude
    @longitude=@event.longitude
    @zoom=12

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.build(params[:event])
    @event[:members]=1
    

    respond_to do |format|
      if @event.valid?
        
        param=params[:event]
        param[:members]=1
        @event=current_user.events.create(param)
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
        q=UsersEvent.find_by_event_id(@event.id)
        q[:role]=true
        q.save

      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def join
   @event = Event.find(params[:event_id])
   
   #@event = Event.find(5)
   

   @users_event = UsersEvent.create!(:event_id=>params[:event_id], :user_id=>current_user.id)
   q=@event.members+1
   @event.update_attributes(:members=>q)
   redirect_to events_path
   # respond_to do |format|
   #   if @users_event.save
   #     format.html { redirect_to @event, notice: 'You have successfully joined to event' }
   #     format.json { head :no_content }
   #   else
   #     format.html { render action: "edit" }
   #     format.json { render json: @users_event, status: :unprocessable_entity }
   #   end
   # end
   end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
