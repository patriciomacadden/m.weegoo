class SubCategory < ActiveRecord::Base
  belongs_to :category
  has_many :points_of_interest, :class_name => "PointOfInterest"
  
  validates :name, :presence => true, :uniqueness => { :scope => :category_id }
end
