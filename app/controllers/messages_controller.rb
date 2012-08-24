class MessagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  # GET /messages
  # GET /messages.json
  




  def chat_show
    @title="Chat with"
    @messages=Message.chat_with_friend(current_user.id,params[:id]).paginate(:page => params[:page])
    @message = Message.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end

  end
  def chat_index
    @title="Chats"
    @messages = current_user.all_chats_with_user.paginate(:page => params[:page])
    @count=@messages.count


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  def index
    @title="Messages"
    @messages = current_user.messages.paginate(:page => params[:page])
Rails.logger.info "__________________search_____________________#{params.inspect}"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end
  
  def reverse
    @title="Reverse Messages"
    @messages = current_user.reverse_messages.paginate(:page => params[:page])
Rails.logger.info "__________________search_____________________#{params.inspect}"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end


  # GET /messages/new
  # GET /messages/new.json
  def new
Rails.logger.info "__________________request_____________________#{request.inspect}"

    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create

    #Rails.logger.info "__________________search_____________________#{params.inspect}"
    
  if params[:message].present? && params[:message][:receiver_id].present?
    receiver = User.find_by_email(params[:message][:receiver_id]).id
  end
  if params[:receiver]
    receiver=params[:receiver]
  end
  
     @message = current_user.messages.build(:content=>params[:message][:content], :receiver_id=>receiver)
    respond_to do |format|
      if @message.valid?
        @message = current_user.messages.create(:content => params[:message][:content], :receiver_id => receiver)
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /messages/1
  # PUT /messages/1.json
  def update
    #receiver=User.find_by_email(params[:message][:receiver_id]).id
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

 

end
