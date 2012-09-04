class Micropost < ActiveRecord::Base
  attr_accessible :content

<<<<<<< HEAD
  belongs_to :usery
=======
  belongs_to :user
>>>>>>> 56d95f618e3744eb3809a5ec2e84dd6c9fa01b42
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
end
