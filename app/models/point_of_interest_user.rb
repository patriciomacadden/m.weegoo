class PointOfInterestUser < ActiveRecord::Base
  belongs_to :point_of_interest
  belongs_to :user
  
  set_table_name "points_of_interest_users"
  
  def self.been(point_of_interest, user)
    point_of_interest_user = user.points_of_interest_users.find_or_initialize_by_point_of_interest_id(point_of_interest.id)
    
    point_of_interest_user.update_attributes!(:been => true, :want_to_go => false)
    
    BeenAtActivity.create!(:user_a_id => user.id, :point_of_interest_id => point_of_interest.id)
  end
  
  def self.not_been(point_of_interest, user)
    point_of_interest_user = user.points_of_interest_users.find_or_initialize_by_point_of_interest_id(point_of_interest.id)
    point_of_interest_user.delete
    
    NotBeenAtActivity.create!(:user_a_id => user.id, :point_of_interest_id => point_of_interest.id)
  end
  
  def self.want_to_go(point_of_interest, user)
    user.points_of_interest_users.create!(:point_of_interest_id => point_of_interest.id, :want_to_go => true)
    
    WantToGoToActivity.create!(:user_a_id => user.id, :point_of_interest_id => point_of_interest.id)
  end
  
  def self.dont_want_to_go(point_of_interest, user)
    point_of_interest_user = user.points_of_interest_users.find_or_initialize_by_point_of_interest_id(point_of_interest.id)
    point_of_interest_user.delete
    
    DontWantToGoToActivity.create!(:user_a_id => user.id, :point_of_interest_id => point_of_interest.id)
  end
end
