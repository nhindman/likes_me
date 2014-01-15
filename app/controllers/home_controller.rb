class HomeController < ApplicationController 
  
  def index
    # binding.pry
    if session[:token] 
      graph = Koala::Facebook::API.new(session[:token])
    end
    # user = graph.get_object("me") 
    #binding.pry
  end
  
end
