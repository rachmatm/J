class WelcomesController < ApplicationController

  #home
  def index
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
    
  end
end