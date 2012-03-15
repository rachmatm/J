class JotsController < ApplicationController
  def create
    respond_to do |format|

      format.json do
        debugger
      end

      format.all { respond_not_found }
    end
  end
end