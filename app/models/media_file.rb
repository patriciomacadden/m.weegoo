class MediaFile < ActiveRecord::Base
  belongs_to :point_of_interest
  belongs_to :user
  
  has_many :media_file_comments
  
  mount_uploader :file, FileUploader
  
  validates :file, :presence => true
  
  after_create :create_media_file_created_activity
  
  PER_PAGE = 20
  LATEST_PER_PAGE = 5
  
  def latest_media_file_comments
    media_file_comments.order("created_at DESC").limit(LATEST_PER_PAGE)
  end
  
  private
  
  def create_media_file_created_activity
    MediaFileCreatedActivity.create!(:user_a_id => self.user.id, :point_of_interest_id => self.point_of_interest.id, :media_file_id => self.id)
  end
end
