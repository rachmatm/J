module SearchAction
  
  class Index < ActionWithAppAuth

    def start
      render Search.get params[:keyword], params[:type]
      finish
    end
  end
end
