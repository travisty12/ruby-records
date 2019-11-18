class Song
  attr_reader :id
  attr_accessor :name, :album_id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @album_id = attributes.fetch(:album_id)
    @id = attributes.fetch(:id)
  end

  def ==(other_song)
    if (other_song != nil)
      (self.name.eql?(other_song.name) && self.album_id.eql?(other_song.album_id))
    else
      false
    end
  end

  def self.all
    returned_songs = DB.exec("SELECT * FROM songs;")
    songs = []
    returned_songs.each() do |song|
      name = song.fetch("name")
      album_id = song.fetch("album_id").to_i
      id = song.fetch("id").to_i
      songs.push(Song.new({:name => name, :album_id => album_id, :id => id}))
    end
    songs
  end

  def save
    result = DB.exec("INSERT INTO songs (name, album_id) VALUES ('#{@name}', #{@album_id}) RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM songs WHERE id = #{id}").first
    if result
      name = result.fetch("name")
      id = result.fetch("id").to_i
      album_id = result.fetch("album_id").to_i
      Song.new({:name => name, :album_id => album_id, :id => id})
    else
      nil
    end
  end

  def self.find_by_album(album_id)
    songs = []
    DB.exec("SELECT * FROM songs WHERE album_id = #{album_id}").each do |song|
      songs.push(Song.new({:name => song.fetch("name"), :album_id => album_id, :id => song.fetch("id").to_i}))
    end
    songs
  end

  def self.search(name)
    output = []
    names = Song.all.map { |a| a.name }.grep(/#{name}/)
    names.each do |song_name|
      output.concat(Song.all.select { |song| song.name == song_name })
    end
    output
  end

  def album
    Album.find(@album_id)
  end

  def update(name, album_id)
    @name = name
    DB.exec("UPDATE songs SET name = '#{@name}', album_id = #{@album_id} WHERE id = #{@id}")
  end

  def delete
    DB.exec("DELETE FROM songs WHERE id = '#{@id}'")
  end

  def self.clear
    DB.exec("DELETE FROM songs *;")
  end
end
