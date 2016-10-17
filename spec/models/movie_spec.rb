
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      
      it 'should return all the movies whose titles include the search terms' do
        search_terms = "Lethal Weapon"
        Movie.find_in_tmdb(search_terms).each {|m| expect(m[:title]).to include(search_terms)}
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  
  describe 'creating Tmdb by Tmdb ID' do
    tmdb_id = 942
    context 'with valid key' do
      it 'should call Tmdb with Tmdb ID' do
        allow(Tmdb::Movie).to receive(:detail).with(tmdb_id).and_return({original_title: "test title", overview: "test overview", release_date: "1900-01-01"})
        expect(Movie).to receive(:_get_rating).with(tmdb_id)
        expect(Movie).to receive(:create)
        Movie.create_from_tmdb(tmdb_id)
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:detail).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.create_from_tmdb(tmdb_id) }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  
  describe 'getting all ratings' do
    it 'should return all rating options' do
      expect(Movie.all_ratings).to eq(["G", "PG", "PG-13", "NC-17", "R"])
    end
  end
end
