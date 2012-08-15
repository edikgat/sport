class Friendship < ActiveRecord::Base
	
  attr_accessible :authorized, :friend_id, :user_id, :friend, :user

  belongs_to :user
  belongs_to :friend, :class_name => "User"

  validates :user_id, :presence => true
  validates :friend_id, :presence => true

  validates :user_id, :uniqueness => { :scope => :friend_id,
    :message => "should be only once" }

  validates :friend_id, :uniqueness => { :scope => :user_id,
    :message => "should be only once" } 

  validate :check_on_uniqueness  

  scope :my_friends, lambda {
    |my_id, friend_id| where("(user_id = (?) AND friend_id = (?)) OR (user_id = (?) AND friend_id = (?))", my_id, friend_id, friend_id, my_id) 
  }
  scope :for_today, where("created_at >= (?)", Date.today.beginning_of_day)
  scope :authorized, where(:authorized => true)
  scope :not_authorized, where(:authorized => false)

  private

  def check_on_uniqueness
    errors[:base] << "Edik Error!" if user_id == friend_id
  end
end
