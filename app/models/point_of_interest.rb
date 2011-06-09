class PointOfInterest < ActiveRecord::Base
  belongs_to :category
  belongs_to :sub_category
  belongs_to :user
  
  has_many :points_of_interest_users, :class_name => "PointOfInterestUser", :dependent => :destroy
  
  has_many :media_files, :dependent => :destroy
  
  has_many :activities, :dependent => :destroy
  
  # these are scopes. don't use them for .create!()
  has_many :been_users, :through => :points_of_interest_users, :source => :user, :conditions => { "points_of_interest_users.been" => true }
  has_many :want_to_go_users, :through => :points_of_interest_users, :source => :user, :conditions => { "points_of_interest_users.want_to_go" => true }
  
  has_many :point_of_interest_comments
  
  set_table_name "points_of_interest"
  
  validates :name, :presence => true, :uniqueness => true
  validates :category, :presence => true
  validates :sub_category, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  
  has_permalink :name, :update => true
  
  # because permalink_fu does not escape the name automatically:
  before_save :handle_permalink
  
  PER_PAGE = 20
  LATEST_PER_PAGE = 5
  
  def to_param
    permalink
  end
  
  def self.search(search, type)
    if search
      if type != "Everything"
        where("(name LIKE ? OR description LIKE ?) AND type = ? AND (date IS NULL OR date >= ?)", "%#{search}%", "%#{search}%", type, "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}").order("name ASC")
      else
        where("(name LIKE ? OR description LIKE ?) AND (date IS NULL OR date >= ?)", "%#{search}%", "%#{search}%", "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}").order("name ASC")
      end
    else
      scoped
    end
  end
  
  def self.most_visited
    points_of_interest = []
    
    PointOfInterestUser.group("point_of_interest_id").order("count(*) DESC").limit(10).each do |point_of_interest_user|
      points_of_interest << point_of_interest_user.point_of_interest
    end
    
    points_of_interest
  end
  
  def been_friends(user)
    user_accepted_friendships_ids = []
    
    user.accepted_friendships.each do |friendship|
      user_accepted_friendships_ids << friendship.friend(user).id
    end
    
    been_users_ids = []
    
    been_users.each do |user|
      been_users_ids << user.id
    end
    
    been_friends_ids = user_accepted_friendships_ids & been_users_ids
    
    User.where("id IN (?)", been_friends_ids)
  end
  
  def want_to_go_friends(user)
    user_accepted_friendships_ids = []
    
    user.accepted_friendships.each do |friendship|
      user_accepted_friendships_ids << friendship.friend(user).id
    end
    
    want_to_go_users_ids = []
    
    want_to_go_users.each do |user|
      want_to_go_users_ids << user.id
    end
    
    want_to_go_friends_ids = user_accepted_friendships_ids & want_to_go_users_ids
    
    User.where("id IN (?)", want_to_go_friends_ids)
  end
  
  def latest_been_users
    been_users.order("points_of_interest_users.created_at DESC").limit(LATEST_PER_PAGE)
  end
  
  def latest_want_to_go_users
    want_to_go_users.order("points_of_interest_users.created_at DESC").limit(LATEST_PER_PAGE)
  end
  
  def latest_been_friends
    been_friends.order("points_of_interest_users.created_at DESC").limit(LATEST_PER_PAGE)
  end
  
  def latest_want_to_go_friends
    want_to_go_friends.order("points_of_interest_users.created_at DESC").limit(LATEST_PER_PAGE)
  end
  
  def latest_media_files
    media_files.order("created_at DESC").limit(LATEST_PER_PAGE)
  end
  
  def latest_point_of_interest_comments
    point_of_interest_comments.order("created_at DESC").limit(LATEST_PER_PAGE)
  end
  
  def can_delete?(user)
    been_users.size == 0 and want_to_go_users.size == 0 and self.user == user
  end
  
  def can_edit?(user)
    self.user == user
  end
  
  protected
    
  def handle_permalink
    self.permalink = PermalinkFu.escape self.name
  end
end
