module PhotoSelect

  def self.get_best_photos(photos_array)
    photos_array.sort!{ |a,b| b[:total_likes] <=> a[:total_likes] }
    
    max_num_tags = 4
    min_num_likes = 1
    best_photos = []

    photos_array.each do |photo|
      if photo[:total_likes] >= min_num_likes && photo[:num_tags] <= max_num_tags
        best_photos << photo
      end
    end
    return best_photos
  end

  def self.batch(token)
    photos_array = self.fb_connect(token)
    get_best_photos(photos_array)
  end

  def self.fb_connect(token)
    graph = Koala::Facebook::API.new(token)
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
    return photos_array
  end

end  