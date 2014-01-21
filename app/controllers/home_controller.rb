class HomeController < ApplicationController 
  
  require Rails.root.join('lib','photoselect')

  include PhotoSelect
  
  def index
    @render = false
    if session[:token]
      @sort_by = params[:sort_by] || :total_likes
      @photos = PhotoSelect::batch(session[:token], @sort_by)
      @render = true
    end
  end

end
