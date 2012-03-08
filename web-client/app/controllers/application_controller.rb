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

    send_request = Typhoeus::Request.new File.join(BASE_URL, path), :params => params, :method => method.parameterize.underscore.to_sym

    # Run the request via Hydra.
    hydra = Typhoeus::Hydra.new
    hydra.queue(send_request)
    hydra.run

    # TODO : need a better logger, notifier is better
    response = send_request.response

    request_to_s = "api_connect #{send_request.response.request.url}, #{send_request.response.request.method} #{send_request.response.request.params}"

    if response.success?
      return ActiveSupport::JSON.decode response.body
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

  
end