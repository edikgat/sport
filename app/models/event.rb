class Event < ActiveRecord::Base
  attr_accessible :description, :event_date, :members, :title
end
