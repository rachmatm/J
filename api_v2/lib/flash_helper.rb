class FlashHelper

  def initialize(session)
    @session = session
    @session[:flash] ||= {}
    @session[:flash_count] ||= 0

    @session[:flash_count] += 1 if @session[:flash].any?

    if @session[:flash_count] > 1
      @session[:flash] = {}
      @session[:flash_count] = 0
    end
  end

  def set_or_get_flash
    @session[:flash]
  end
end
