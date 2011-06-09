class Friendship < ActiveRecord::Base
  belongs_to :user_a, :foreign_key => :user_a_id, :class_name => "User"
  belongs_to :user_b, :foreign_key => :user_b_id, :class_name => "User"
  
  def accept
    update_attributes!(:are_friends => true)
    
    AcceptedFriendshipActivity.create!(:user_a_id => user_a.id, :user_b_id => user_b.id)
  end
  
  def friend(user)
    user == user_a ? user_b : user_a
  end
end
