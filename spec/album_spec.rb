require('rspec')
require('album')
require 'song'

describe('#Album') do
  before(:each) do
    Album.clear()
  end

  describe(".all") do
    it("returns an empty array when there are no albums") do
      expect(Album.all()).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an album") do
      album = Album.new("Giant Steps", nil)
      album.save()
      album2 = Album.new("Blue",nil)
      album2.save()
      expect(Album.all).to(eq([album, album2]))
    end
  end

  describe('#==') do
    it("is the same albu if it has the same attributes as another album") do
      album = Album.new("Blue", nil)
      album2 = Album.new("Blue", nil)
      expect(album).to(eq(album2))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      album = Album.new("Giant Steps", nil)
      album.save()
      album2 = Album.new("Blue",nil)
      album2.save()
      Album.clear()
      expect(Album.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Album.new("Giant Steps", nil)
      album.save()
      album2 = Album.new("Blue",nil)
      album2.save()
      expect(Album.find(album.id)).to(eq(album))
    end
  end

  describe('#update') do
    it("updates an album by id") do
      album = Album.new("Giant Steps", nil)
      album.save()
      album.update("Blue")
      expect(album.name).to(eq("Blue"))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      album = Album.new("Giant Steps", nil)
      album.save()
      album2 = Album.new("Blue",nil)
      album2.save()
      album.delete()
      expect(Album.all).to(eq([album2]))
    end
  end

  describe('.search') do
    it("finds an album by name") do
      album = Album.new("Giant Steps", nil)
      album.save()
      album2 = Album.new("Blue",nil)
      album2.save()
      album3 = Album.new("Plates Of Fish",nil)
      album3.save()
      expect(Album.search("te")).to(eq([album, album3]))
    end
  end

  describe('#songs') do
    it("returns an album's songs") do
      album = Album.new("Giant Steps", nil)
      album.save()
      song = Song.new("Cousin Mary", album.id, nil)
      song.save()
      song2 = Song.new("Naima", album.id, nil)
      song2.save()
      expect(album.songs).to(eq([song, song2]))
    end
  end
end
