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

  #def create
    #respond_to do |format|

      #format.json do
        #debugger
      #end

      #format.all { respond_not_found }
    #end
  #end

  def index
    jot_index_response = api_connect('me/jots.json', {}, 'get', false, true)

    if jot_index_response['failed'] === false
      @jot = jot_index_response['content']
    else
      redirect_to root_path, :notice => "You have no jot to be shown."
    end
  end
end
