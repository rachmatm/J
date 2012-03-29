class ApplicationController < ActionController::Base
  protect_from_forgery

  def api_connect(path, parameters, method = 'post')

    parameters = {} unless parameters.is_a? Hash

    token = params[:token] || cookies[:jotky_token] || session[:jotky_token]

    parameters.merge! :app_id => JOTKY_ID, :secret_key => JOTKY_SECRET, :token => token

    send_request = request_connect :url => File.join(JOTKY_BASE_URL, path), :params => parameters, :method => method.parameterize.underscore.to_sym do |response|
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

  rescue Exception => error
    return {'failed' => true,
      'error' => "Terminating Request to API, raised unrecoverable error :(. #{error}"}
  end

  def respond_not_found
    render :file => "#{Rails.root}/public/404.html", :status => :not_found, :content_type => 'text/html'
  end
end
