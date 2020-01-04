require 'spec_helper'


describe('#Artist') do

  describe(".all") do
    it("returns an empty array when there are no artists") do
      expect(Artist.all()).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an artist") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      artist2 = Artist.new({:name => "Louis Armstrong", :id => nil})
      artist2.save
      expect(Artist.all).to(eq([artist, artist2]))
    end
  end

  describe('#==') do
    it("is the same albu if it has the same attributes as another artist") do
      artist = Artist.new({:name => "Louis Armstrong", :id => nil})
      artist2 = Artist.new({:name => "Louis Armstrong", :id => nil})
      expect(artist).to(eq(artist2))
    end
  end

  describe('.clear') do
    it("clears all artists") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      artist2 = Artist.new({:name => "Louis Armstrong", :id => nil})
      artist2.save
      Artist.clear
      expect(Artist.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an artist by id") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      artist2 = Artist.new({:name => "Louis Armstrong", :id => nil})
      artist2.save
      expect(Artist.find(artist.id)).to(eq(artist))
    end
  end

  describe('#update') do
    it("updates an artist by id") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      artist.update({:name => "Louis Armstrong"})
      expect(artist.name).to(eq("Louis Armstrong"))
    end

    it("adds an album to an artist") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      album = Album.new({ :name => "Blue", :id => nil })
      album.save
      album2 = Album.new({:name => "Giant Steps", :id => nil})
      album2.save()
      artist.update({:album_name => "Blue" })
      artist.update({:album_name => "Giant Steps" })
      expect(artist.albums).to(eq([album, album2]))
    end

    it("ignores duplicate album updates") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      album = Album.new({ :name => "Blue", :id => nil })
      album.save
      artist.update({:album_name => "Blue" })
      artist.update({:album_name => "Blue" })
      expect(artist.albums).to(eq([album]))
    end
  end

  describe('#delete') do
    it("deletes an artist by id") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      artist2 = Artist.new({:name => "Louis Armstrong", :id => nil})
      artist2.save
      artist.delete()
      expect(Artist.all).to(eq([artist2]))
    end
  end

  describe('.search') do
    it("finds an artist by name") do
      artist = Artist.new({:name => "Miles Davis", :id => nil})
      artist.save
      artist2 = Artist.new({:name => "Louis Armstrong", :id => nil})
      artist2.save
      artist3 = Artist.new({:name => "Dizzy", :id => nil})
      artist3.save
      expect(Artist.search("s")).to(eq([artist, artist2]))
    end
  end

end
