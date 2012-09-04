class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @title = "My events"
    @titlesearch
    @events = current_user.events.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end
<<<<<<< HEAD


  def master
    @title ="Events that i create"
=======


  def master
    @title="Events that i create"
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
    @events = current_user.master_events.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  def joined
    @title="Joined events"
    users_events = current_user.users_events.where(:role => false)
    events = []
    users_events.each do |user_event|
      events << user_event.event
    end
    events.compact!
<<<<<<< HEAD
    @events = events.paginate(:page => params[:page])
=======
    @events=events.paginate(:page => params[:page])
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
    respond_to do |format|
      format.html 
    end
  end

  def all
<<<<<<< HEAD
    @title = "All events"
=======
    @title="All events"
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
    @events = Event.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  def show
    @event = Event.find(params[:id])
<<<<<<< HEAD
    @width = 500
    @latitude = @event.latitude
    @longitude = @event.longitude
    @zoom = 12
=======
    @width=500
    @latitude=@event.latitude
    @longitude=@event.longitude
    @zoom=12
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
    respond_to do |format|
      format.html
    end
  end

  def new
    @event = Event.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = current_user.events.build(params[:event])
<<<<<<< HEAD
    @event[:members] = 1
=======
    @event[:members]=1
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
    respond_to do |format|
      if @event.valid?      
        param=params[:event]
        param[:members] = 1
        @event = current_user.events.create(param)
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
       # format.json { render json: @event, status: :created, location: @event }
<<<<<<< HEAD
        UsersEvent.find_by_event_id_and_user_id(@event.id,current_user.id).update_attributes(role: true)
=======
        q=UsersEvent.find_by_event_id_and_user_id(@event.id,current_user.id)
        q[:role]=true
        q.save
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

   def join
  #  Rails.logger.info "__________________params_____________________#{params.inspect}" 
   @event = Event.find(params[:event_id])
    if current_user.join_event?(@event)
     flash.now[:success] = "You could not join to this event"
    else
     flash.now[:error] = "You have joined to this event"
    end
    redirect_to events_path
  end



  def destroy

    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
    end
  end


  def search
<<<<<<< HEAD
   if @event = Event.find_by_title(params[:Search][:title123])
=======
   if @event=Event.find_by_title(params[:Search][:title123])
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
   redirect_to @event
   else
    redirect_to events_path
    end
  end

  def index_search
    @events = Event.order(:title).where("title like ?", "%#{params[:term]}%")
    render json: @events.map(&:title)
  end



end
