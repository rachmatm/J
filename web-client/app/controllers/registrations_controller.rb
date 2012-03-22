class RegistrationsController < ApplicationController
  layout 'application3'
  
  def create

    respond_to do |format|
      
      format.html do
        parameters = {
          privatekey: '6LeUR80SAAAAAHFGOMAxHZ0hpLmFjjpPA15gHePZ',
          remoteip: '127.0.0.1',
          challenge: params[:recaptcha_challenge_field],
          response: params[:recaptcha_response_field]
        }

        send_request = request_connect :url => 'http://www.google.com/recaptcha/api/verify', :params => parameters, :method => :post do |response|
          if response.body.split("\n").first == "true"
            api_connect 'registration.json', params[:registration], 'post', true
          else
            {'failed' => true, 'error' => 'The CAPTCHA solution was incorrect.'}
          end
        end

        if send_request["failed"] === false
          set_token({:key => send_request['token']}, params[:remember_me])

          flash[:signup_notice] = send_request['notice']
          redirect_to :root
        else
          @registration = params[:registration]
          flash[:signup_error] = send_request['error']
          flash[:signup_errors] = send_request['errors']
          render 'new'
        end
      end

      format.all { respond_not_found }
    end
  end

  def new

    respond_to do |format|
      format.html do
        @registration = {}
      end
    end
  end
end
