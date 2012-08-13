class Friendship < ActiveRecord::Base
	
  attr_accessible :authorized, :friend_id, :user_id
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  validates :user_id, :presence => true
  validates :friend_id, :presence => true
  #validates :user_id, :uniqueness => { :scope => :friend_id,
  #  :message => "should happen once per year" }
  def could_make_friendship?(user_id,friend_id)
  	unless Friendship.find_by_user_id_and_friend_id(user_id,friend_id)
  		rerurn true
  	else
  		unless Friendship.find_by_user_id_and_friend_id(friend_id,user_id)
  			return true
  		else
  			return false
  		end
  	end
end
end
