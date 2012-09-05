class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @title = "Messages"
    @messages = current_user.messages.paginate(:page => params[:page])
  end
  
  def reverse
    @title = "Reverse Messages"
    @messages = current_user.reverse_messages.paginate(:page => params[:page])
  end

   def chat_show
    @title = "Chat with"
    @messages = Message.chat_with_friend(current_user.id,params[:id]).paginate(:page => params[:page])
    @message = Message.new
  end

  def chat_index
    @title = "Chats"
    @messages = current_user.all_chats_with_user.paginate(:page => params[:page])
    @count = @messages.count
  end
  
  def reverse
    @title = "Reverse Messages"
    @messages = current_user.reverse_messages.paginate(:page => params[:page])
  end

  def chat_show
    @title = "Chat with"
    @messages = Message.chat_with_friend(current_user.id,params[:id]).paginate(:page => params[:page])
    @message = Message.new
  end
  
  def chat_index
    @title = "Chats"
    @messages = current_user.all_chats_with_user.paginate(:page => params[:page])
    @count = @messages.count
  end

  def show
    @message = Message.find(params[:id])
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
    receiver_id = User.find_by_email(email).id
    
    @message = current_user.messages.build(
      :content => params[:Message_to_user][:content], 
      :receiver_id => receiver_id
    )

    if @message.save
      redirect_to (chat ? chat_path(receiver_id) : @message), notice: 'Message was successfully created.'
    else
      flash[:error] = 'Something wrong'
      render action: "new"
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
