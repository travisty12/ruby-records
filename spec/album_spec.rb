require 'spec_helper'


describe('#Album') do

  describe(".all") do
    it("returns an empty array when there are no albums") do
      expect(Album.all()).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an album") do
      album = Album.new({:name => "Giant Steps", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      expect(Album.all).to(eq([album, album2]))
    end
  end

  describe('#==') do
    it("is the same albu if it has the same attributes as another album") do
      album = Album.new({:name => "Blue", :id => nil})
      album2 = Album.new({:name => "Blue", :id => nil})
      expect(album).to(eq(album2))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      album = Album.new({:name => "Giant Steps", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      Album.clear()
      expect(Album.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Album.new({:name => "Giant Steps", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      expect(Album.find(album.id)).to(eq(album))
    end
  end

  describe('#update') do
    it("updates an album by id") do
      album = Album.new({:name => "Giant Steps", :id => nil})
      album.save
      album.update({ :name => "Blue" })
      expect(album.name).to(eq("Blue"))
    end

    it("adds an artist to an album") do
      album = Album.new({:name => "Blue", :id => nil})
      album.save
      artist = Artist.new({ :name => "Miles Davis", :id => nil })
      artist.save
      artist2 = Artist.new({:name => "John Coltrane", :id => nil})
      artist2.save
      album.update({:artist_name => "Miles Davis" })
      album.update({:artist_name => "John Coltrane" })
      expect(album.artists).to(eq([artist, artist2]))
    end

    it("ignores duplicate album updates") do
      album = Album.new({:name => "Blue", :id => nil})
      album.save
      artist = Artist.new({ :name => "Miles Davis", :id => nil })
      artist.save
      album.update({:artist_name => "Miles Davis" })
      album.update({:artist_name => "Miles Davis" })
      expect(album.artists).to(eq([artist]))
    end
  end

  describe('#delete') do
    it("deletes all songs belonging to a deleted album") do
      album = Album.new({:name =>"A Love Supreme", :id => nil})
      album.save
      song = Song.new({:name => "Naima", :album_id => album.id, :id => nil})
      song.save
      album.delete
      expect(Song.find(song.id)).to(eq(nil))
    end
    
    it("deletes an album by id") do
      album = Album.new({:name => "Giant Steps", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      album.delete()
      expect(Album.all).to(eq([album2]))
    end
  end

  describe('.search') do
    it("finds an album by name") do
      album = Album.new({:name => "Giant Steps", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      album3 = Album.new({:name => "Plates Of Fish", :id => nil})
      album3.save()
      expect(Album.search("te")).to(eq([album, album3]))
    end
  end

  describe('#songs') do
    it("returns an album's songs") do
      album = Album.new({:name => "Giant Steps", :id => nil})
      album.save()
      song = Song.new({:name => "Giant Steps", :album_id => album.id, :id => nil})
      song.save()
      song2 = Song.new({:name => "Naima", :album_id => album.id, :id => nil})
      song2.save()
      expect(album.songs).to(eq([song, song2]))
    end
  end
end
