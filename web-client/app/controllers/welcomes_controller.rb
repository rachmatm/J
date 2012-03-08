class WelcomesController < ApplicationController

  #home
  def index
  end

  def member
    render :layout => 'private'
  end

  def hot_stuff
  end

  def profile
  end

  def profile_other
  end
  
  def inbox
    render :layout => 'private'
  end  


  #FOOTER
  def terms
  end

  def contact
  end

  def goodies
  end

  def api
  end

  def help
  end

  def privacy
  end



end