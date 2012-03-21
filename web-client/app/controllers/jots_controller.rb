class JotsController < ApplicationController
  layout 'application3'
  before_filter :validate_auth_user
  
  def new

  end

  def create
    respond_to do |format|
      format.html do
        if params[:attachments].present?
          uploader = MediaUploader.new
          uploader.store! params[:attachments]
          params.merge!({:attachments => File.open(uploader.path, 'r')})
        end
        jot_create_response = api_connect('me/jots.json', params, 'post', false, true)
        uploader.remove! if params[:attachments].present?
        redirect_to new_jot_path, :notice => jot_create_response['notice']
      end

      format.json do
        render :json => api_connect('me/jots.json', params[:jot], 'post', false, true)
      end

      format.all { respond_not_found }
    end
  end

  def thumbsup
    respond_to do |format|
      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/thumbsup.json", {}, 'post', false, true)
      end

      format.all { respond_not_found }
    end
  end

  def thumbsdown
    respond_to do |format|
      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/thumbsdown.json", {}, 'post', false, true)
      end

      format.all { respond_not_found }
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}.json", {}, 'delete', false, true)
      end

      format.all { respond_not_found }
    end
  end

  def index
    
    respond_to do |format|
      format.json do
        unless @current_user.present?
          render :json => api_connect('jots/index.json', params[:jot], 'get', true)
        else
          render :json => api_connect('me/jots.json', params[:jot], 'get', true, true)
        end
      end

      format.html do
      end

      format.all { respond_not_found }
    end
  end


  def show
    respond_to do |format|
      format.html do
        data = api_connect("/jots/index.json", {:id => params[:id]}, 'get', true, true)

        if data['failed'] === true
          respond_not_found
        else
          @jot = data['content'] || {}
        end
      end
    end
  end

  def create_comments
    respond_to do |format|
      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/comments.json", params[:comment], 'post', true, true)
      end

      format.all { respond_not_found }
    end
  end
end
