module FileAction
  class Create < ActionWithTokenAuth

    def start
      render Attachment.set params
      finish
    end
  end
end