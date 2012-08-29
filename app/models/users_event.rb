class UsersEvent < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :role
  
  belongs_to :event
  belongs_to :user

  validates :event_id, :presence => true
  validates :user_id, :presence => true
end
