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
  end

  def profile_other
  end
  
  def inbox
    render :layout => 'private'
  end

  def new_index
    render :layout => 'application2'
  end
end