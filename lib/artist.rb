class Artist
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.all
    returned_artists = DB.exec("SELECT * FROM artists;")
    artists = []
    returned_artists.each do |artist|
      name = artist.fetch("name")
      id = artist.fetch("id").to_i
      artists.push(Artist.new({ :name => name, :id => id }))
    end
    artists
  end

  def self.find(id)
    artist = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
    if artist 
      name = artist.fetch("name")
      id = artist.fetch("id").to_i
      Artist.new({:name => name, :id => id })
    else
      nil
    end
  end

  def update(attributes)
    if (attributes.has_key?(:name) && attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name) 
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    end

    if (attributes.has_key?(:album_name) && attributes.fetch(:album_name) != nil)
      album_name = attributes.fetch(:album_name)
      album = DB.exec("SELECT * FROM albums WHERE lower(name) = '#{album_name.downcase}';").first
      if album != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
      end
    end

  end

  def delete
    DB.exec("DELETE FROM albums_artists WHERE artist_id = #{@id}")
    DB.exec("DELETE FROM artists WHERE id = #{@id};") 
  end

  def self.clear
    DB.exec("DELETE FROM artists *;")
  end

  def ==(other_artist)
    self.name.eql?(other_artist.name)
  end

  def self.search(name)
    returned_artists = []
    names = Artist.all.map { |artist| artist.name }.grep(/#{name}/)
    names.each do |name|
      returned_artists.concat(Artist.all.select {|artist| artist.name == name})
    end
    returned_artists
  end

  def songs
    # Song.find_by_artist(@id)
  end

  def albums
    albums = []
    album_id_strings = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id};")
    album_ids = album_id_strings.map { |result| result.fetch("album_id").to_i }
    results = DB.exec("SELECT * FROM albums WHERE id IN (#{album_ids.join(', ')});")
    results.each do |result|
      album_id = result.fetch("id").to_i
      name = result.fetch("name")
      albums.push(Album.new({ :name => name, :id => album_id }))
    end
    albums
  end

end
