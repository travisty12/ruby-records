class Album
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    if album
      name = album.fetch("name")
      id = album.fetch("id").to_i
      Album.new({:name => name, :id => id})
    else
      nil
    end
  end

  def update(attributes)
    if (attributes.has_key?(:name) && attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id}")
    end

    if (attributes.has_key?(:artist_name) && attributes.fetch(:artist_name) != nil)
      artist_name = attributes.fetch(:artist_name)
      artist = DB.exec("SELECT * FROM artists WHERE lower(name) = '#{artist_name.downcase}';").first
      if artist != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{@id}, #{artist['id'].to_i});")
      end
    end
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM albums_artists WHERE album_id = #{@id}")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
  end

  def self.clear()
    DB.exec("DELETE FROM albums *;")
  end

  def ==(other_album)
    self.name.eql?(other_album.name) # && self.artist.eql?(other_album.artist) && etc
  end

  def self.search(name)
    output = []
    names = Album.all.map { |a| a.name }.grep(/#{name}/)
    names.each do |album_name|
      output.concat(Album.all.select { |album| album.name == album_name })
    end
    output
  end

  def songs
    Song.find_by_album(@id)
  end
  
  def artists
    artists = []
    artist_id_strings = DB.exec("SELECT artist_id FROM albums_artists WHERE album_id = #{@id};")
    artist_ids = artist_id_strings.map { |result| result.fetch("artist_id").to_i }
    results = DB.exec("SELECT * FROM artists WHERE id IN (#{artist_ids.join(', ')});")
    results.each do |result|
      artist_id = result.fetch("id").to_i
      name = result.fetch("name")
      artists.push(Artist.new({ :name => name, :id => artist_id }))
    end
    artists
  end

end


class InheritsFromAlbum < Album
  def self.all()
    @@albums
  end
end
