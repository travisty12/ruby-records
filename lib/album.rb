class Album
  attr_reader :id, :name

  @@albums = {}
  @@total_rows = 0

  def initialize(name, id)
    @name = name
    @id = id || @@total_rows += 1
  end

  def save
    @@albums[self.id] = Album.new(self.name, self.id)
    # @@albums[self.id] = self
  end

  def self.all
    @@albums.values()
  end

  def self.find(id)
    @@albums[id]
  end

  def update(name)
    @name = name
  end

  def delete
    @@albums.delete(self.id)
  end

  def self.clear()
    @@albums = {}
    @@total_rows = 0
  end

  def ==(other_album)
    self.name.eql?(other_album.name) # && self.artist.eql?(other_album.artist) && etc
  end

end

class InheritsFromAlbum < Album
  def self.all()
    @@albums
  end
end
