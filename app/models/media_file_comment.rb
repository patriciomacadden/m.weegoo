class MediaFileComment < ActiveRecord::Base
  belongs_to :media_file
  belongs_to :user
  
  after_create :create_media_file_comment_created_activity
  
  private
  
  def create_media_file_comment_created_activity
    MediaFileCommentCreatedActivity.create!(:user_a_id => self.user.id, :point_of_interest_id => self.media_file.point_of_interest.id, :media_file_id => self.media_file.id)
  end
end
