class TwitterController < ApplicationWithTokenController
  def timeline
    @timeline = api_connect('me/twitter/timeline.json', {}, 'get', false, true)['content']
  end

  def status
    
  end

  def post_status
    post_twitter_status_response = api_connect('me/twitter/status.json', params, 'post', false, true)

    if post_twitter_status_response['failed'] === false
      redirect_to status_twitter_path, :notice => post_twitter_status_response['notice']
    else
      flash[:error] = post_twitter_status_response['error']
      redirect_to status_twitter_path
    end
  end
end
