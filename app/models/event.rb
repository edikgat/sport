class Event < ActiveRecord::Base
	
  attr_accessible :description, :event_date, :members, :title, :latitude, :longitude
  has_many :users_events
  has_many :users, :through => :users_events
  



  validates :title, :presence => true,:length => { :maximum => 140 }
  validates :members, :presence => true
  validates :event_date, :presence => true
  validates :description, :presence => true,:length => { :maximum => 1500 }
  def coordinates_array?()
    
  end
   

end
