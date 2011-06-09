class DontWantToGoToActivity < Activity
  after_create :broadcast
  
  private
  
  def broadcast
    message = "I don't want to go to #{self.point_of_interest.name}: #{points_of_interest_url(self.point_of_interest)}"
    tweet(message)
    post(message)
  end
end
