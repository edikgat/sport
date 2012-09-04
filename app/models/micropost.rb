class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :usery
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
end
