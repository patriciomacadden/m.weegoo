class Category < ActiveRecord::Base
  has_many :sub_categories
  has_many :points_of_interest
  
  validates :name, :presence => true, :uniqueness => true
end
