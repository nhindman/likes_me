class HomeController < ApplicationController 
  
  def index

    @render = false
    
    if session[:token] 
      graph = Koala::Facebook::API.new(session[:token])
      photos = graph.get_connection("me", "photos", {:limit => 30}) 
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
      photos_array.sort!{ |a,b| b[:total_likes] <=> a[:total_likes] }

      # Select best photos based on total user likes and maximum number of tags
      @num_best_photos = 0
      @photos = []
      max_num_tags = 4
      photos_array.each do |photo|
        if photo[:total_likes] > 0 && photo[:num_tags] <= max_num_tags
          @photos << photo
          @num_best_photos += 1
        end
        @render = true
      end
    end
  end
end
