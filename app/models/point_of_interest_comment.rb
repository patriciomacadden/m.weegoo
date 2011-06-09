class PointOfInterestComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :point_of_interest
  
  after_create :create_point_of_interest_comment_created_activity
  
  private
  
  def create_point_of_interest_comment_created_activity
    PointOfInterestCommentCreatedActivity.create!(:user_a_id => self.user.id, :point_of_interest_id => self.point_of_interest.id)
  end
end
