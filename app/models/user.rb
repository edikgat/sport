class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :birth_date, :description, :email, :first_name,
    :last_name,:email, :password, :password_confirmation, :remember_me
 
  has_many :microposts, :dependent => :destroy

  has_many :users_events
  has_many :events, :through => :users_events
  has_many :master_events, :through => :users_events, :source => :event, :conditions => [ "role = ?", true]

  has_many :messages, :foreign_key => "sender_id", :dependent => :destroy
  has_many :reverse_messages, :class_name => "Message", :foreign_key => "receiver_id", :dependent => :destroy                               
  has_many :receivers, :through => :messages, :source => :receiver
  has_many :senders, :through => :reverse_messages, :source => :sender

  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user, :conditions => [ "authorized = ?", false ]
  
  has_many :my_authorized_friends, :through => :friendships, :source => :friend, :conditions => [ "authorized = ?", true ]
  has_many :inverse_authorized_friends, :through => :inverse_friendships, :source => :user, :conditions => [ "authorized = ?", true ]
  has_many :unauthorized_friends, :through => :friendships, :source => :friend, :conditions => [ "authorized = ?", false ]


   scope :friends_wich_accepted,  lambda {
    |my_id|   User.find(my_id).my_authorized_friends + User.find(my_id).inverse_authorized_friends }



  def can_add_to_friends?(friend)
    Friendship.my_friends(id, friend.id).present? || (id == friend.id) ? false : true
  end
  

  #def add_to_friends!(friend)
  # friendships.create!(:friend => friend)
  #end
end



