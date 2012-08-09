class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :birth_date, :description, :email, :first_name,
  :last_name,:email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
 

######################

  #microposts
  has_many :microposts, :dependent => :destroy
  #events
  has_many :users_events
  has_many :events, :through => :users_events
  has_many :master_events, :through => :users_events, :source => :event, :conditions => { :role => true }



  #messages
  has_many :messages, :dependent => :destroy,
                           :foreign_key => "sender_id" #исх сообщения
  has_many :reverse_messages, :dependent => :destroy,
                                   :foreign_key => "receiver_id", 
                                   :class_name => "Message" #вх сообщения#

  has_many :receivers, :through => :messages, :source => :receiver
  has_many :senders, :through => :reverse_messages,
                       :source => :sender

  #friendships
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :authorized_friends, :through => :friendships, :source => :friend,
  :conditions => { :authorized => true } 

####################

end
