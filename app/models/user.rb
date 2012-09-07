class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :birth_date, :description, :email, :first_name,
    :last_name,:email, :password, :password_confirmation, :remember_me

  has_many :microposts, dependent: :destroy

  has_many :users_events, dependent: :destroy
  has_many :events, through: :users_events
  has_many :master_events, through: :users_events, source: :event, conditions: [ "role = ?", true]

  has_many :messages, foreign_key: "sender_id", dependent: :destroy
  has_many :reverse_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy

  has_many :receivers, through: :messages, source: :receiver
  has_many :senders, through: :reverse_messages, source: :sender

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user, conditions: [ "authorized = ?", false ]
  
  has_many :my_authorized_friends, through: :friendships, source: :friend, conditions: [ "authorized = ?", true ]
  has_many :inverse_authorized_friends, through: :inverse_friendships, source: :user, conditions: [ "authorized = ?", true ]
  has_many :unauthorized_friends, through: :friendships, source: :friend, conditions: [ "authorized = ?", false ]

  scope :friends_wich_accepted,  lambda {
    |my_id|   User.find(my_id).my_authorized_friends + User.find(my_id).inverse_authorized_friends }
  
  validates_date :birth_date, before: lambda { 18.years.ago },
    before_message: "must be at least 18 years old"

  # FRIENDSHIP METHODS - BEGIN
  def can_add_to_friends?(friend)
    !my_friend?(friend) && !(id == friend.id)
  end
  
  def my_friend?(friend)
    Friendship.my_friends(id, friend.id).present?
  end
  
  def add_to_friends!(friend)
    friendships.create!(friend: friend)
  end
  # FRIENDSHIP METHODS - END
  
  # EVENTS METHODS - BEGIN
  def find_user_event(event)
    users_events.where(event_id: event.id).first
  end
  
  def can_join?(event)
    find_user_event(event).blank?
  end

  def can_edit_event?(event)
    user_event = find_user_event(event)
    user_event.present? && user_event.role?
  end
  
  def join_event!(event)
    if can_join?(event)
       users_events.create(event_id: event.id)
       event.update_attributes(members: event.members + 1)
    end
  end
   # EVENTS METHODS - END

   # MESSAGES METHODS - BEGIN
  def unique_ids(all_messages)
    all_id_pairs = all_messages.map { |c| [c.sender_id, c.receiver_id] }
    unique_ids = all_id_pairs.flatten
    unique_ids = unique_ids.uniq.reject! { |i| i == id }
  end

  def chat_with
    all_messages = Message.all_messages_with_user(id)
    chat_pairs = []
    unique_ids(all_messages).each_with_index do |unique_id|
      chat_pairs << all_messages.
        select { |c| c.sender_id == unique_id || c.receiver_id == unique_id }
    end
    chat_pairs
  end

  def all_chats_with_user
    chats = []
    chat_with.each_with_index  do | message, i| 
      chats[i] = { message: message[0], count: message.size }
      end
      chats
  end
 
    def giv_chat_user(message)
      if message.sender_id == id
        User.find(message.receiver_id)
      else
        User.find(message.sender_id)
      end
    end


  # MESSAGES METHODS - END
end



