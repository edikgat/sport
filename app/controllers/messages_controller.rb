class MessagesController < ApplicationController
  before_filter :authenticate_user!

 
  def index
<<<<<<< HEAD
    @title = "Messages"
    @messages = current_user.messages.paginate(:page => params[:page])
=======
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
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
    respond_to do |format|
      format.html
    end
  end
<<<<<<< HEAD
  
  def reverse
    @title="Reverse Messages"
    @messages = current_user.reverse_messages.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

   def chat_show
    @title = "Chat with"
    @messages = Message.chat_with_friend(current_user.id,params[:id]).paginate(:page => params[:page])
    @message = Message.new
    respond_to do |format|
      format.html
    end

  end
  def chat_index
    @title="Chats"
    @messages = current_user.all_chats_with_user.paginate(:page => params[:page])
    @count = @messages.count
    respond_to do |format|
      format.html
    end
  end


=======


>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
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
<<<<<<< HEAD
    chat = 0
    exit = 0
  if params[:receiver_email].present?
    receiver_id = User.find_by_email(params[:receiver_email]).id
    chat = 1
  else
    if params[:Message_to_user][:receiver_email].present?
    receiver_id = User.find_by_email(params[:Message_to_user][:receiver_email]).id
    else  
      exit = 1
    end
  end
  if exit == 1
    redirect_to new_message_path
  else
  @message = current_user.messages.build(:content => params[:Message_to_user][:content], :receiver_id => receiver_id)
    respond_to do |format|
      if @message.valid?
        @message = current_user.messages.create(:content=>params[:Message_to_user][:content], :receiver_id => receiver_id)
        if chat == 0
=======
    chat=0;
    exit=0
  if params[:receiver_email].present?
    receiver_id=User.find_by_email(params[:receiver_email]).id
    chat=1;
  else
    if params[:Message_to_user][:receiver_email].present?
    receiver_id=User.find_by_email(params[:Message_to_user][:receiver_email]).id
    else  
 
      exit=1
    end
  end
  if exit==1
    redirect_to new_message_path
  else
  @message = current_user.messages.build(:content=>params[:Message_to_user][:content], :receiver_id=>receiver_id)
    respond_to do |format|
      if @message.valid?
        @message = current_user.messages.create(:content=>params[:Message_to_user][:content], :receiver_id=>receiver_id)
        if chat==0
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
          format.html { redirect_to @message, notice: 'Message was successfully created.' }
         else
          format.html { redirect_to chat_path(receiver_id), notice: 'Message was successfully created.' }
        end
      else
        format.html { render action: "new" }
      end
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
