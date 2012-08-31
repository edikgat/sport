class MessagesController < ApplicationController
  before_filter :authenticate_user!

 
  def index
    @title="Messages"
    @messages = current_user.messages.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end
  
  def reverse
    @title="Reverse Messages"
    @messages = current_user.reverse_messages.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

   def chat_show
    @title="Chat with"
    @messages=Message.chat_with_friend(current_user.id,params[:id]).paginate(:page => params[:page])
    @message = Message.new
    respond_to do |format|
      format.html
    end

  end
  def chat_index
    @title="Chats"
    @messages = current_user.all_chats_with_user.paginate(:page => params[:page])
    @count=@messages.count
    respond_to do |format|
      format.html
    end
  end


  def show
    @message = Message.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @message = Message.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create    
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
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def update
    @message = Message.find(params[:id])
    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
    end
  end

end
