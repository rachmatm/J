class WelcomesController < ApplicationWithTokenController

  #home
  def index
    if @current_user.present?
      render 'index_member', :layout => 'private2'
    else
      render 'new_index', :layout => 'application2'
    end
    
  end

  def member
    render :layout => 'private'
  end

  def hot_stuff
    render :layout => 'private'
  end

  def profile
     render :layout => 'private'
  end

  def profile_other
    render :layout =>'private'
  end

  def search_people
      render :layout => 'private'
  end

  def jot_detail_active
    render  :layout => 'private'
  end
  
  def inbox
    render :layout => 'private'
  end

  def new_index
    render :layout => 'application2'
  end
end