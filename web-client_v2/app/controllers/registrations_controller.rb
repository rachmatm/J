class RegistrationsController < ApplicationController

  def create
    
    respond_to do |format|
      
      format.json do
        
        parameters = {
          privatekey: RECAPTCHA_PRIVATE_KEY,
          remoteip: RECAPTCHA_REMOTE_IP,
          challenge: params[:recaptcha_challenge_field],
          response: params[:recaptcha_response_field]
        }

        send_request = request_connect :url => RECAPTCHA_VERIFY_URL, :params => parameters, :method => :post do |response|
          if response.body.split("\n").first == "true"
            api_connect 'registration.json', params[:registration], 'post'
          else
            {'failed' => true, 'error' => 'The CAPTCHA solution was incorrect.'}
          end
        end

        render :json => send_request
      end

      format.all { respond_not_found }
    end
  end
end