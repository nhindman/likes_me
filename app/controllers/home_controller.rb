class HomeController < ApplicationController 
  
  def index

    @render = false
    
    if session[:token] 
      graph = Koala::Facebook::API.new(session[:token])

      # binding.pry
      photos = graph.get_connection("me", "photos", {:limit => 5}) 

      photos_array = []
     
      photos.each do |photo|   
        all_likes = graph.get_connection( photo["id"], "likes" )
        male_likes = 0
        female_likes = 0
        all_likes.each do |like|
          gender = graph.get_object(like["id"])["gender"]
          if gender == "male"
            male_likes += 1
          else
            female_likes += 1
          end
        end
        hash = {
          id: photo["id"],
          url: photo["source"],
          num_tags: graph.get_connection( photo["id"], "tags" ).count,
          male_likes: male_likes,
          female_likes: female_likes,
          total_likes: male_likes + female_likes,
          }
        photos_array << hash
      end
      @photos = photos_array.sort!{ |a,b| b[:total_likes] <=> a[:total_likes] }
      @render = true
    end
  end

end
