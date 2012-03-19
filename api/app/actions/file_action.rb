module FileAction
  class Create < ActionWithTokenAuth

    def start
       start_with_validates_params [:file] do
         Attachment.set @parameters
       end
    end
  end
end