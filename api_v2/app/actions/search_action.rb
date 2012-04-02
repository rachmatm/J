module SearchAction
  
  class Index < ActionWithAppAuth

    def start
      
      render Search.get params[:keyword]
      finish
    end
  end
end