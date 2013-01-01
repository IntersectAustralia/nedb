class PagesController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:admin]

  def home
  end
  
  def admin
  end
  
end
