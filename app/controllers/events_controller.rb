class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

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
   event.update_attributes(:members=>event.members+1)
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
