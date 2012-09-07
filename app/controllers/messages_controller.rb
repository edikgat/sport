class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @title = "Messages"
    @messages = current_user.messages.paginate(page: params[:page])
    @users = @messages.map { |message| User.find(message.receiver_id) }
  end
  
  def reverse
    @title = "Reverse Messages"
    @messages = current_user.reverse_messages.paginate(page: params[:page])
    @users = @messages.map { |message| User.find(message.sender_id) }
    
  end

   def chat_show
    @title = "Chat with"
    @messages = Message.chat_with_friend(current_user.id,params[:id]).paginate(page: params[:page])
    @message = Message.new
  end
 

  def chat_show
    @title = "Chat with"
    @messages = Message.chat_with_friend(current_user.id,params[:id]).paginate(page: params[:page])
    @message = Message.new
    @title=User.find(params[:id]).first_name
    @senders = []
    @senders = @messages.map { |message| User.find(message.sender_id).email }
    @receivers = []
    @receivers = @messages.map { |message| User.find(message.receiver_id).email }
    @receiver_email = current_user.giv_chat_user(@messages[0]).email
  end
  
  def chat_index
    @title = "Chats"
    @messages = current_user.all_chats_with_user.map { |chat| chat[:message] }.paginate(page: params[:page])
    @count = current_user.all_chats_with_user.map { |chat| chat[:count] }
    @chat_users = @messages. map { |message| current_user.giv_chat_user(message) }
  end

  def show
    @message = Message.find(params[:id])
    @sender=User.find(@message.sender_id).email
    @receiver=User.find(@message.receiver_id).email
  end

  def new
    @message = Message.new
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    email = params[:receiver_email].present? ? params[:receiver_email] : params[:Message_to_user][:receiver_email]
    chat = true if params[:receiver_email].present?
    if a = User.find_by_email(email)
      receiver_id =  a.id
      @message = current_user.messages.build(
      content: params[:Message_to_user][:content], 
      receiver_id: receiver_id
      )
      if @message.save
        redirect_to (chat ? chat_path(receiver_id) : @message), notice: 'Message was successfully created.'
      else
        flash[:error] = 'Something wrong'
        render action: "new"
      end
    else
      flash[:error] = 'Email incorrect'
      redirect_to new_message_path
    end
  end
  
  def update
    @message = Message.find(params[:id])
    
    if @message.update_attributes(params[:message])
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    
    redirect_to messages_url
  end
end
