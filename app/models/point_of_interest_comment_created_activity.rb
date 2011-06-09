class PointOfInterestCommentCreatedActivity < Activity
  after_create :broadcast
  
  private
  
  def broadcast
    message = "I've commented the #{self.point_of_interest.type.downcase} #{self.point_of_interest.name}: #{points_of_interest_url(self.point_of_interest)}"
    tweet(message)
    post(message)
  end
end
