class Song
  attr_reader :id
  attr_accessor :name, :album_id

  @@songs = {}
  @@total_rows = 0

  def initialize(name, album_id, id)
    @name = name
    @album_id = album_id
    @id = id || @@total_rows += 1
  end

  def ==(other_song)
    (self.name == other_song.name) && (self.album_id == other_song.album_id)
  end

  def self.all
    @@songs.values
  end

  def save
    @@songs[self.id] = Song.new(self.name, self.album_id, self.id)
  end

  def self.find(id)
    @@songs[id]
  end

  def self.find_by_album(album_id)
    songs = []
    @@songs.values.each do |song|
      if song.album_id == album_id
        songs.push(song)
      end
    end
    songs
  end

  def album
    Album.find(self.album_id)
  end

  def update(name, album_id)
    self.name = name
    self.album_id = album_id
    @@songs[self.id] = Song.new(self.name, self.album_id, self.id)
  end

  def delete
    @@songs.delete(self.id)
  end

  def self.clear
    @@songs = {}
  end
end
