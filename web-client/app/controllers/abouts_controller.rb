class AboutsController < ApplicationController
  layout 'application3'
  before_filter :validate_auth_user

  
end