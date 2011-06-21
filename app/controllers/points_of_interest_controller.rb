class PointsOfInterestController < ApplicationController
  # GET /points_of_interests
  # GET /points_of_interests.xml
  def index
    if params[:search]
      @points_of_interest = PointOfInterest.search(params[:search], params[:type])
    else
      @points_of_interest = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @points_of_interest }
    end
  end
  
  def show
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
  end
  
  def browse_categories
    @categories = Category.all
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @categories }
    end
  end
  
  def browse_sub_categories
    @category = Category.find(params[:category_id])
    @sub_categories = @category.sub_categories
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @sub_categories }
    end
  end
  
  def map
    @points_of_interest = PointOfInterest.all
  end
  
  def categories_map
    @category = Category.find(params[:category_id])
    
    @points_of_interest = @category.points_of_interest
  end
  
  def sub_categories_map
    @sub_category = SubCategory.find(params[:sub_category_id])
    
    @points_of_interest = @sub_category.points_of_interest
  end
  
  ###
  def been
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    PointOfInterestUser.been(@point_of_interest, current_user)
    
    respond_to do |format|
      format.html { redirect_to(@point_of_interest) }
    end
  end
  
  def not_been
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    PointOfInterestUser.not_been(@point_of_interest, current_user)
    
    respond_to do |format|
      format.html { redirect_to(@point_of_interest) }
    end
  end
  
  def want_to_go
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    PointOfInterestUser.want_to_go(@point_of_interest, current_user)
    
    respond_to do |format|
      format.html { redirect_to(@point_of_interest) }
    end
  end
  
  def dont_want_to_go
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    PointOfInterestUser.dont_want_to_go(@point_of_interest, current_user)
    
    respond_to do |format|
      format.html { redirect_to(@point_of_interest) }
    end
  end
  
  def been_users
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    @users = @point_of_interest.been_users
    
    respond_to do |format|
      format.html
    end
  end
  
  def want_to_go_users
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    @users = @point_of_interest.want_to_go_users
    
    respond_to do |format|
      format.html
    end
  end
  
  # arreglar estos dos metodos
  def been_friends
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    @users = @point_of_interest.been_friends(current_user)
    
    respond_to do |format|
      format.html
    end
  end
  
  def want_to_go_friends
    @point_of_interest = PointOfInterest.find_by_permalink(params[:id])
    
    @users = @point_of_interest.want_to_go_friends(current_user)
    
    respond_to do |format|
      format.html
    end
  end
end
