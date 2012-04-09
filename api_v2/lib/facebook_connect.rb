class FacebookConnect

  attr_accessor :user_id, :token

  def initialize(user_id, token, api_url = 'https://graph.facebook.com')
    @user_id = user_id
    @token = token
    @api_url = api_url
  end

  def publish(type, parameters = {})

    case type
    when 'wall'
      path = '/me/feed'
    when 'videos'
      path = '/me/videos'
    when 'photos'
      path = '/me/photos'
    else
      path = ''
    end

    request = Typhoeus::Request.new(File.join(@api_url, path),
      :method        => :post,
      :params        => parameters.merge({:access_token => @token}))
    # we can see from this that the first argument is the url. the second is a set of options.
    # the options are all optional. The default for :method is :get. Timeout is measured in milliseconds.
    # cache_timeout is measured in seconds.

    request_response = ActiveSupport::JSON.decode(get_data(request))

    case type
    when 'videos'
      show(request_response['id'])
    when 'photos'
      show(request_response['post_id'])
    else
      request_response
    end
    
  end

  def show(obj_id)

    request = Typhoeus::Request.new(File.join(@api_url, obj_id),
      :method        => :get,
      :params        => parameters.merge({:access_token => @token}))


    request_response = ActiveSupport::JSON.decode(get_data(request))
  end

  def test(url, params)
    request = Typhoeus::Request.new(url,
      :method        => :get,
      :params        => params.merge({:access_token => @token}))

    return get_data(request)
  end

  protected

  def get_data(request)

    # Run the request via Hydra.
    hydra = Typhoeus::Hydra.new
    hydra.queue(request)
    hydra.run

    # the response object will be set after the request is run
    response = request.response
    
    if response.success?
      Cramp.logger.info "hell yeah"
    elsif response.timed_out?
      Cramp.logger.info "aw hell no, got a time out"
    elsif response.code == 0
      Cramp.logger.info "Could not get an http response, something's wrong."
    else
      Cramp.logger.info "HTTP request failed: " + response.code.to_s
    end

    return response.body
  end
end