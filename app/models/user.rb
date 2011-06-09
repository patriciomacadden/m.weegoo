class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :location, :username, :password, :password_confirmation, :remember_me
  
  # Associations
  has_many :friendships, :foreign_key => :user_a_id, :dependent => :destroy
  
  has_many :points_of_interest_users, :class_name => "PointOfInterestUser"
  
  has_many :activities, :foreign_key => :user_a_id
  
  has_many :media_files
  
  has_many :authentications
  
  has_many :points_of_interest
  
  has_many :point_of_interest_comments
  has_many :media_file_comments
  
  # these are scopes. don't use them for .create!()
  has_many :been_points_of_interest, :through => :points_of_interest_users, :source => :point_of_interest, :conditions => { "points_of_interest_users.been" => true }
  has_many :want_to_go_points_of_interest, :through => :points_of_interest_users, :source => :point_of_interest, :conditions => { "points_of_interest_users.want_to_go" => true }
  
  # Validations
  validates :username, :presence => true, :uniqueness => true, :format => /^[A-Za-z\d_]+$/
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :location, :presence => true
  
  PER_PAGE = 20
  
  def to_param
    username
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def self.search(search)
    if search
      where("first_name LIKE ? OR last_name LIKE ?", "%#{search}%", "%#{search}%").order("last_name ASC")
    else
      scoped
    end
  end
  
  def self.most_active
    users = []
    
    Activity.group("user_a_id").order("count(*) DESC").limit(10).each do |activity|
      users << activity.user_a
    end
    
    users
  end
  
  def is_friend?(another_user)
    accepted_friendships.exists?(["user_a_id = ? OR user_b_id = ?", another_user.id, another_user.id])
  end
  
  def waiting_for_confirmation?(another_user)
    friendships.exists?(:user_b_id => another_user.id, :are_friends => false)
  end
  
  def pending_friendships
    Friendship.where(:user_b_id => id, :are_friends => false)
  end
  
  def accepted_friendships
    Friendship.where("(user_a_id = ? OR user_b_id = ?) AND are_friends = ?", id, id, true)
  end
  
  def mutual_friends(another_user)
    accepted_friendships_ids = []
    
    accepted_friendships.each do |friendship|
      accepted_friendships_ids << friendship.friend(self).id
    end
    
    another_user_accepted_friendships_ids = []
    
    another_user.accepted_friendships.each do |friendship|
      another_user_accepted_friendships_ids << friendship.friend(another_user).id
    end
    
    mutual_ids = accepted_friendships_ids & another_user_accepted_friendships_ids
    
    User.where("id IN (?)", mutual_ids)
  end
  
  def been_at(point_of_interest)
    been_points_of_interest.include?(point_of_interest)
  end
  
  def want_to_go_to(point_of_interest)
    want_to_go_points_of_interest.include?(point_of_interest)
  end
  
  # returns own and friends activities.
  def related_activities
    ids = [id]
    
    accepted_friendships.each do |friendship|
      ids << friendship.friend(self).id
    end
    
    Activity.where("(user_a_id IN (?) OR user_b_id IN (?)) AND created_at > ?", ids, ids, created_at).order("created_at DESC").group("id")
  end
  
  def apply_omniauth(omniauth)
    self.email = omniauth["user_info"]["email"] if email.blank?
    authentications.build(:provider => omniauth["provider"], :uid => omniauth["uid"], :token => (omniauth['credentials']['token'] rescue nil))
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def valid_password?(password)
    not password_required? && super(password)
  end
  
  def authenticates_to?(provider)
    authentications.exists?(:provider => provider)
  end
  
  def facebook_authentication
    @facebook_authentication ||= authentications.where("provider = ?", "facebook").first
  end
  
  def twitter_authentication
    @twitter_authentication ||= authentications.where("provider = ?", "twitter").first
  end
  
  def facebook_friends
    users_ids = []
    
    facebook_user = FbGraph::User.me(facebook_authentication.token)
    
    facebook_user.friends.each do |facebook_friend|
      authentication = Authentication.where("uid = ?", facebook_friend.identifier).first
      if authentication
        users_ids << authentication.user_id
      end
    end
    
    if users_ids.size > 0
      @facebook_friends ||= User.where("id IN (?)", users_ids)
    else
      @facebook_friends ||= []
    end
  end
  
  def twitter_friends
    users_ids = []
    Twitter.friends(twitter_authentication.uid.to_i).users.each do |twitter_user|
      authentication = Authentication.where("uid = ?", twitter_user.id).first
      if authentication
        users_ids << authentication.user_id
      end
    end
    
    if users_ids.size > 0
      @twitter_friends ||= User.where("id IN (?)", users_ids)
    else
      @twitter_friends ||= []
    end
  end
end
