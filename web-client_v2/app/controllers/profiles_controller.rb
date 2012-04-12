class ProfilesController < ApplicationController
  def show
    respond_to do |format|

      format.json do
        render :json => api_connect('/me.json', {}, "get")
      end
      
      format.all { respond_not_found }
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|

      format.json do
        if params[:swfUpload].present? and params[:avatar].present?
          uploader = ClipUploader.new
          uploader.store!(params[:avatar])

          request_response = api_connect('/me.json', {:avatar => File.open(uploader.path)}, "post")

          uploader.remove!

          render :json => request_response
        else
          render :json => api_connect('/me.json', params[:profile], "post")
        end
      end

      format.all { respond_not_found }
    end
  end

  def destroy

  end
end