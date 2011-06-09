class NotBeenAtActivity < Activity
  after_create :broadcast
  
  private
  
  def broadcast
    message = "I've not been at #{self.point_of_interest.name}: #{points_of_interest_url(self.point_of_interest)}"
    tweet(message)
    post(message)
  end
end
