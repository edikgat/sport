class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id

  belongs_to :receiver, :class_name => "User"
  belongs_to :sender, :class_name => "User"

  validates :content, :presence => true, :length => { :minimum => 1 }
  
  scope :all_messages_with_user, lambda {
     |user_id| where("(receiver_id= (?)) OR (sender_id= (?))",user_id,user_id).order("created_at DESC")  
   }

  scope :all_chats_with_user, lambda{
  |my_id|  all_messages_with_user(my_id).group("sender_id", "receiver_id")
  }

  scope :chat_with_friend, lambda{
  |user_id,friend_id|  where("( receiver_id= (?)  AND sender_id= (?)  ) OR ( receiver_id= (?)  AND sender_id= (?)  )", user_id, friend_id, friend_id, user_id).order("created_at DESC")
  }


end
