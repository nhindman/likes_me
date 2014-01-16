module PhotoSelect

  def self.fb_connect(token)
    graph = Koala::Facebook::API.new(token)
    photos = graph.get_connection("me", "photos", {:limit => 5}) 
  
    populate_likes_and_tags!(photos, graph)
 
    photos.map do |photo|
      all_likes = photo["likes"]   
      
      {
        id: photo["id"],
        url: photo["source"],
        num_tags: photo["tag_count"],
        male_likes: all_likes.count{|l| l[:gender] == "male"},
        female_likes: all_likes.count{|l| l[:gender] == "female"},
        total_likes: all_likes.length,
      }
    end
  end

  def self.populate_likes_and_tags!(photos, graph)
    photos.each do |photo|
      photo["tag_count"] = graph.get_connection( photo["id"], "tags" ).count
      photo["likes"] = graph.get_connection( photo["id"] , "likes" , {:limit => 25} )
      photo["likes"].each do |like|
        like[:gender] = graph.get_object(like["id"])["gender"]
      end     
    end
  end

  def self.get_best_photos(photos_array, sort_by)
    sort_by = sort_by.to_sym
    photos_array.sort!{ |a,b| b[sort_by] <=> a[sort_by] }
    max_num_tags = 4
    min_num_likes = 1
    best_photos = []
   # binding.pry
    if photos_array
      photos_array.each do |photo|
        # binding.pry
        if photo[:num_tags] <= max_num_tags && photo[sort_by] >= min_num_likes
          best_photos << photo
        end
      end
    end
    return best_photos
  end

  def self.batch(token, sort_by)
    photos_array = self.fb_connect(token)

    get_best_photos(photos_array, sort_by)

  end

end  