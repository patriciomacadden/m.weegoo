class MediaFileCommentCreatedActivity < Activity
  after_create :broadcast
  
  private
  
  def broadcast
    message = "I've commented the media file of the #{self.point_of_interest.type.downcase} #{self.point_of_interest.name}: #{points_of_interest_media_file_media_file_comments_url(self.point_of_interest, self.media_file)}"
    tweet(message)
    post(message)
  end
end
