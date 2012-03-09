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
  end

  def profile_other
  end
  
  def inbox
    render :layout => 'private'
  end  


 



end