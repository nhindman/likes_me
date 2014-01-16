class HomeController < ApplicationController 
  
  require Rails.root.join('lib','photoselect')

  include PhotoSelect
  
  def index
    @render = false
    if session[:token]
      @photos = PhotoSelect::batch( session[:token] )
      @render = true
    end
  end
  
end
