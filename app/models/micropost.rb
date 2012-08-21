class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content, :presence => true,:length => { :in => 1..400 }
end
