class Category < ActiveRecord::Base
  has_many :sub_categories
  has_many :points_of_interest, :class_name => "PointOfInterest"
  
  validates :name, :presence => true, :uniqueness => true
end
