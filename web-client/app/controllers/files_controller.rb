class FilesController < ApplicationWithTokenController
  
  def create
    respond_to do |format|

      format.json do
        uploader = MediaUploader.new
        uploader.store! params[:Filedata]

        render :json => api_connect('files.json', {:file => File.open(uploader.path)}, 'post', true, true)
      end

      format.all { respond_not_found }
    end
  end
end