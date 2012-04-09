class ClipsController < ApplicationController

  def create
    respond_to do |format|

      format.json do
        if params[:clip].present? and params[:swfUpload].present?
          uploader = ClipUploader.new
          uploader.store! params[:clip]

          render :json => api_connect('/me/clips.json', {:file => File.open(uploader.path) }, "post")
        end
      end

      format.all { respond_not_found }
    end
  end

  def destroy
    
  end
end