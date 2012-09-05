class Event < ActiveRecord::Base
  attr_accessible :description, :event_date, :members, :title, :latitude, :longitude, :photo, :result

  has_many :users_events, :dependent => :destroy
  has_many :users, :through => :users_events
  
  has_attached_file :photo

  validates :title, :presence => true,:length => { :maximum => 140 }
  validates :members, :presence => true
  validates :event_date, :presence => true
  validates :description, :presence => true,:length => { :maximum => 1500 }
  
  scope :with_coordinates, where("latitude is not NULL AND longitude is not NULL")
  
  def event_title=(title)
    Category.find_by_title(title) if title.present?
  end
end
