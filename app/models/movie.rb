class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      movies = []
      matching_movies = Tmdb::Movie.find(string)
      if not matching_movies.nil?
        matching_movies.each do |m|
          movies << {:tmdb_id => m.id, :title => m.title, :rating => self._get_rating(m.id), :release_date => m.release_date}
        end
      end
      
      return movies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.create_from_tmdb(tmdb_id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    detail = Tmdb::Movie.detail(tmdb_id)
    Movie.create(title: detail["original_title"], rating: self._get_rating(tmdb_id), description: detail["overview"], release_date: detail["release_date"])
  end
  
  def self._get_rating(tmdb_id)
    rating = ''
    Tmdb::Movie.releases(tmdb_id)["countries"].each do |r|
      if r["iso_3166_1"] == "US"
        rating = r["certification"]
        break
      end
    end
    return rating
  end

end
