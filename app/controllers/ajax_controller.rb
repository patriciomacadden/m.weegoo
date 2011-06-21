class AjaxController < ApplicationController
  def update_sub_categories
    sub_categories = SubCategory.where(:category_id => params[:category_id]).order("name")
    
    options = sub_categories.collect { |x| "{\"id\": \"#{x.id}\", \"name\": \"#{x.name}\"}" }
    
    render :text => "[#{options.join(", ")}]"
  end
end
