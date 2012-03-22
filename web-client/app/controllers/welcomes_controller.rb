class WelcomesController < ApplicationWithTokenController

  #home
  def index
    if @current_user.present?
      render 'index_member', :layout => 'private2'
    else
      cookies.delete :user_name
      render 'new_index', :layout => 'application2'
    end
  end

  def jot
    
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
    debugger
    render :layout =>'private'
    @notification_for_user = @current_user['notifications'].select { |n| n['type'] == 'user' }.present? ? @current_user['notifications'].select { |n| n['type'] == 'user' } : []
    @notification_for_user_jot = @current_user['notifications'].select { |n| n['type'] == 'jot' }
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
    render 'index'
  end
end
