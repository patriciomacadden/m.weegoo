class Event < PointOfInterest
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  
  after_create :create_event_created_activity
  
  def self.upcoming
    where("date >= ?", "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}").order("date ASC")
  end
  
  private
  
  def create_event_created_activity
    EventCreatedActivity.create!(:user_a_id => self.user.id, :point_of_interest_id => self.id)
  end
end
