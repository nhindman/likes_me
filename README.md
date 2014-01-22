#LIKES ME

##Find your best facebook photos!

* Best photos selected based on 
  * number of likes
    * 1 min
  * number of other people in the photo
    * 4 max
* Photos can be sorted by
  * total likes
  * likes by females only
  * likes by males only
* Photos can be exported to dating websites - not implemented yet
  * OKCupid
  * tinder
  
  
##Visit
HEROKU: http://likes-me.herokuapp.com

##Screenshots

![Example1](public/images/male_example.png)
1. Organize photos by popularity (All Likes, By Females, By Males)

![Example1](public/images/female_example.png)
2. Another example. Find your most liked images!

![Example1](public/images/male_example2.png)
3. Even more fun than facebook.

![Example1](public/images/male_example3.png)
4. Export directly to *OkCupid* and *tinder* - not yet implemented

##Testing!
![Testing coverage](public/images/test_coverage.png)

##Implementation
Incorporates Facebook's Graph API using the [*Koala gem*](http://rubygems.org/gems/koala).

Uses batched facebook queries to improve efficiency and reduce API calls.
In the example below, in order to organize "Likes" by gender, data related to each user that has liked an individual photo is retrieved in the same API call as each photo's list of associated "Likes". 

```ruby
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

```


###Thanks for visiting!!


