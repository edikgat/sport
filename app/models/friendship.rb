class Friendship < ActiveRecord::Base
  attr_accessible :authorized, :friend_id, :user_id
end
