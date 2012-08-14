class Friendship < ActiveRecord::Base
	
  attr_accessible :authorized, :friend_id, :user_id
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  validates :user_id, :presence => true
  validates :friend_id, :presence => true
  #validates :user_id, :uniqueness => { :scope => :friend_id,
  #  :message => "should happen once per year" }
  #public
  end
