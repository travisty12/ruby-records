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

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id}")
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
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
end

class InheritsFromAlbum < Album
  def self.all()
    @@albums
  end
end
