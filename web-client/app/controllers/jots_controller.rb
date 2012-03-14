class JotsController < ApplicationWithTokenController
  def new

  end

  def create
    jot_create_response = api_connect('me/jots.json', params, 'post', false, true)
    facebook_post_status_response = api_connect('me/facebook/status.json', { :message => params[:title] }, 'post', false, true) if @current_user['facebook_id'].present?
    twitter_post_status_response = api_connect('me/twitter/status.json', { :status => params[:title] }, 'post', false, true) if @current_user['twitter_id'].present?

    if jot_create_response['failed'] === false
      redirect_to root_path, :notice => "Your jot was posted"
    else
      redirect_to new_jot_path
    end
  end
end
