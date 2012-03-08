class WelcomesController < ApplicationController
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
end