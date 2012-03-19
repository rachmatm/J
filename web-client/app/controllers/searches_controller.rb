class SearchesController < ApplicationController
  layout 'application3'
  before_filter :validate_auth_user
  
  def index
  end
end