class Venue < PointOfInterest
  after_create :create_venue_created_activity
  
  private
  
  def create_venue_created_activity
    VenueCreatedActivity.create!(:user_a_id => self.user.id, :point_of_interest_id => self.id)
  end
end
