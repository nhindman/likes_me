class HomeController < ApplicationController 
  
  def index
    # binding.pry
    if session[:token] 
      graph = Koala::Facebook::API.new(session[:token])
      photos = graph.get_connection("me", "photos", {:limit => 10})

      photos_array = []
      photos.each do |photo|
        hash = {id: photo["id"], url: photo["source"]}
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
        hash[:male_likes] = male_likes
        hash[:female_likes] = female_likes
        hash[:total_likes] = male_likes + female_likes
        photos_array << hash
      end
    end
    @photos = photos_array.sort!{ |a,b| b[:total_likes] <=> a[:total_likes] }
    # binding.pry
  end
  
end
