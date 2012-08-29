class Event < ActiveRecord::Base
  attr_accessible :description, :event_date, :members, :title, :latitude, :longitude, :photo, :result

  has_many :users_events
  has_many :users, :through => :users_events


  has_attached_file :photo#, :styles => { :medium => "400x400>", :thumb => "100x100>" }

  #, :styles => { :small => "150x150>" },
              #      :url => "/assets/images/products/:id/:style/:basename.:extension",
              #      :path => ":rails_root/app/assets/images/products/:id/:style/:basename.:extension"
  
  #validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 15.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']



  validates :title, :presence => true,:length => { :maximum => 140 }
  validates :members, :presence => true
  validates :event_date, :presence => true
  validates :description, :presence => true,:length => { :maximum => 1500 }
  scope :with_coordinates, where("latitude is not NULL AND longitude is not NULL")
  #scope :authorized, where(:authorized => true)
 # def category_name
 #   category.try(:name)
 # end
 
  def event_title=(title)
    Category.find_by_title(title) if title.present?
  end

end
