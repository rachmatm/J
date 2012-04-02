class FacebookConnect

  attr_accessor :user_id, :token

  def initialize(options = {})
    @options = options
    @options[:grap_url] ||= "https://graph.facebook.com"
  end

  def post_wall(parameters = {})

    request = Typhoeus::Request.new(File.join(@options[:grap_url], "/#{@user_id}/feed"),
      :method        => :post,
      :params        => parameters.merge({:access_token => self.token}))
    # we can see from this that the first argument is the url. the second is a set of options.
    # the options are all optional. The default for :method is :get. Timeout is measured in milliseconds.
    # cache_timeout is measured in seconds.

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
  end
end