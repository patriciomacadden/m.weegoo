class AcceptedFriendshipActivity < Activity
  after_create :broadcast
  
  private
  
  def broadcast
    message = "#{self.user_a.full_name} and I are now friends: #{user_url(self.user_a)}"
    tweet(message)
    post(message)
  end
end
