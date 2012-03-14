class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # API
  def api_connect(path, params, method = 'post', with_app_id = false, with_token = false)

    if with_app_id.present? and params.present? and params.is_a? Hash
      params.merge! :app_id => APP_ID, :secret_key => APP_SECRET
    elsif with_app_id.present?
      params = {:app_id => APP_ID, :secret_key => APP_SECRET}
    end

    if with_token.present? and params.present? and params.is_a? Hash
      params.merge! :token => get_token[:key]
    elsif with_token.present?
      params = {:token => get_token[:key]}
    end

    send_request = request_connect :url => File.join(BASE_URL, path), :params => params, :method => method.parameterize.underscore.to_sym do |response|
      ActiveSupport::JSON.decode response.body
    end
  end

  def request_connect(parameters, &block)
    send_request = Typhoeus::Request.new parameters[:url], :params => parameters[:params], :method => parameters[:method]

    # Run the request via Hydra.
    hydra = Typhoeus::Hydra.new
    hydra.queue(send_request)
    hydra.run

    # TODO : need a better logger, notifier is better
    response = send_request.response

    request_to_s = "api_connect #{send_request.response.request.url}, #{send_request.response.request.method} #{send_request.response.request.params}"

    if response.success?
      return yield response
    elsif response.timed_out?

      logger.fatal ">>>>>>> api_connect: #{request_to_s} \n got a time out!"
      return {'failed' => true,
        'error' => 'aw hell no, got a time out'}
    elsif response.code == 0

      logger.fatal ">>>>>>> api_connect: #{request_to_s} \n Could not get an http response, something's wrong. error: #{response.curl_error_message}"
      return {'failed' => true,
        'error' => "Could not get an http response, something's wrong. error: #{response.curl_error_message}"}
    else

      logger.fatal ">>>>>>> api_connect: #{request_to_s} \n Received a non-successful http response. HTTP request failed: #{response.code.to_s}"
      return {'failed' => true,
        'error' => "Received a non-successful http response. HTTP request failed: #{response.code.to_s}"}
    end
    #rescue
    #  logger.fatal ">>>>>>> Terminating Request to API, raised unrecoverable error!!! \n api_connect: #{request_to_s}"
    return {'failed' => true,
      'error' => "Terminating Request to API, raised unrecoverable error :("}

  rescue
    return {'failed' => true,
      'error' => "Terminating Request to API, raised unrecoverable error :("}
  end

  # AUTH
  def set_token(hash_of_data, remember_me = nil)
    session[:token] = Hash.new
    session[:token].merge! hash_of_data
    session[:token][:last_input_time] = Time.now
    session[:token][:remember_me] = true if remember_me.present?
  end

  def unset_token
    session[:token] = nil
  end

  def get_token
    session[:token]
  end

  def token_auth?
    if (get_token.present? and (30.minutes.from_now get_token[:last_input_time]) > Time.now) || (get_token.present? and get_token[:remember_me].present?)
      true
    else
      false
    end
  end

  def render_500
    render :status => 500, :file => Rails.root.join('public/500.html'), :content_type => 'text/html', :layout => nil
  end

  # HTML error respond template
  def respond_not_found
    render :file => "#{Rails.root}/public/404.html", :status => :not_found, :content_type => 'text/html'
  end
end
