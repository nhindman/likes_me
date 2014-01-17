module PhotoSelect

  def self.fb_connect(token)
    graph = Koala::Facebook::API.new(token)
    photos = graph.get_connection("me", "photos", {:limit => 50}) 
 
    populate_likes_and_tags!(photos, graph)
 
    return photos.map do |photo| 
      {
        id: photo["id"],
        url: photo["source"],
        num_tags: photo["tag_count"],
        male_likes: photo["male_likes"],
        female_likes: photo["female_likes"],
        total_likes: photo["male_likes"] + photo["female_likes"],
      }
    end
  end

  def self.populate_likes_and_tags!(photos, graph)
      photos.each do |photo|
        photo["tag_count"] = graph.get_connection( photo["id"], "tags" ).count
        results = graph.batch do |batch_api|
          batch_api.get_connections(photo["id"], "likes", {:limit => 25}, :batch_args => {:name => "get-likes", :omit_response_on_success => false})
          batch_api.get_objects("{result=get-likes:$.data.*.id}")  
        end
        
        male_likes = 0
        female_likes = 0
        if results[1].class == Hash   
          results[1].each do |k,v|
            if v["gender"] == "male"
              male_likes += 1
            else
              female_likes += 1
            end
          end
        end
        photo["male_likes"] = male_likes
        photo["female_likes"] = female_likes
      end
  end

  def self.get_best_photos(photos_array, sort_by)
    sort_by = sort_by.to_sym
    photos_array.sort!{ |a,b| b[sort_by] <=> a[sort_by] }
    max_num_tags = 3
    min_num_likes = 1
    best_photos = []
    if photos_array
      photos_array.each do |photo|
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