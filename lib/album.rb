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
    returned_albums = DB.exec("SELECT * FROM albums ORDER BY name ASC;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id} ORDER BY name ASC;").first
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
      artist = DB.exec("SELECT * FROM artists WHERE lower(name) = '#{artist_name.downcase}' ORDER BY name ASC;").first
      if artist != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES(#{@id}, #{artist['id'].to_i}) ON CONFLICT (id) DO UPDATE SET album_id = #{@id}, artist_id = #{artist['id'].to_i};")
      end
    end
    
    if (attributes.has_key?(:artist_to_remove) && attributes.fetch(:artist_to_remove) != nil)
      artist_to_remove = attributes.fetch(:artist_to_remove)
      artist = DB.exec("SELECT * FROM artists WHERE lower(name) = '#{artist_to_remove.downcase}' ORDER BY name ASC;").first
      if artist != nil
        DB.exec("DELETE FROM albums_artists WHERE album_id = #{@id} AND artist_id = #{artist['id'].to_i};")
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
    albums = []
    results = DB.exec("SELECT * FROM albums WHERE name ILIKE '%#{name}%' ORDER BY name ASC")
    results.each do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def songs
    Song.find_by_album(@id)
  end
  
  def artists
    artists = []
    results = DB.exec("SELECT artists.* FROM albums JOIN albums_artists ON (albums.id = albums_artists.album_id) JOIN artists ON (albums_artists.artist_id = artists.id) WHERE albums.id = #{@id};")
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
