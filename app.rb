#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require './lib/album'
require './lib/song'
require './lib/artist'
require 'pry'
require 'pg'
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "ruby_records"})

## Splash

get('/') do
  @albums = Album.all
  @artists = Artist.all
  @songs = Song.all
  erb(:home)
end

## Albums

get('/albums') do # GET all albums
  if params[:search]
    @search = true;
    @term = params[:search]
    @albums = Album.search(@term)
  else
    @search = false;
    @albums = Album.all
  end
  erb(:albums)
end

post('/albums') do # CREATE album
  name = params[:album_name]
  album = Album.new({:name => name, :id => nil})
  album.save()
  redirect to('/albums')
end

get('/albums/new') do 
  erb(:new_album)
end

get('/albums/:id') do # GET one album
  @album = Album.find(params[:id].to_i())
  if @album
    @artists = Artist.all
    erb(:album)
  else
    erb(:not_found)
  end
end

patch('/albums/:id') do # UPDATE album, GET all albums
  album = Album.find(params[:id].to_i)
  if params[:name]
    album.update({ :name => params[:name] })
  elsif params[:artist_name]
    album.update({ :artist_name => params[:artist_name] })    
  elsif params[:artist_to_remove]
    album.update({ :artist_to_remove => params[:artist_to_remove] })
  end
  redirect to('/albums/' + album.id.to_s)
end

delete('/albums/:id') do # DELETE album
  album = Album.find(params[:id].to_i())
  album.delete()
  redirect to('/albums')
end

post('/albums/:id/songs') do # POST song to album, GET parent album
  @album = Album.find(params[:id].to_i())
  song = Song.new({:name => params[:song_name], :album_id => @album.id, :id => nil})
  song.save()
  redirect to('/albums/' + @album.id.to_s)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

get('/albums/:id/songs/:song_id') do # GET one song, if child of parent album
  @song = Song.find(params[:song_id].to_i())
  if @song
    erb(:song)
  else
    erb(:not_found)
  end
end

patch('/albums/:album_id/songs/:id') do # UPDATE one song, GET parent album
  @album = Album.find(params[:album_id].to_i())
  song = Song.find(params[:id].to_i())
  song.update(params[:name], @album.id)
  redirect to('/albums/' + @album.id.to_s)
end

delete('/albums/:id/songs/:song_id') do # DELETE one song, GET parent album
  song = Song.find(params[:song_id].to_i())
  song.delete()
  @album = Album.find(params[:id].to_i())
  redirect to('/albums/' + @album.id.to_s)
end

## Songs

get('/songs') do # GET all songs
  if params[:search]
    @search = true
    @term = params[:search]
    @songs = Song.search(@term)
  else
    @search = false
    @songs = Song.all
  end
  erb(:songs)
end

# get('/songs/:id') do # GET one song -- regardless of parent album
#   @song = Song.find(params[:id].to_i())
# end

## Artists

get('/artists') do # GET all artists
  if params[:search]
    @artists = Artist.search(params[:search])
  else
    @artists = Artist.all
  end
  erb(:artists)
end

get('/artists/new') do
  erb(:new_artist)
end

get('/artists/:id') do # GET one artist
  @artist = Artist.find(params[:id].to_i)
  if @artist
    @albums = Album.all
    erb(:artist)
  else
    erb(:not_found)
  end
end

post('/artists') do # POST artist, GET all artists
  name = params[:artist_name]
  artist = Artist.new({ :name => name, :id => nil })
  artist.save
  redirect to('/artists')
end

patch('/artists/:id') do # UPDATE artist, GET all artists
  artist = Artist.find(params[:id].to_i)
  if params[:name]
    artist.update({ :name => params[:name] })
  elsif params[:album_name]
    artist.update({ :album_name => params[:album_name]} )
  elsif params[:album_to_remove]
    artist.update({ :album_to_remove => params[:album_to_remove]})
  end
  redirect to('/artists/' + artist.id.to_s)
end

delete('/artists/:id') do # DELETE artist, GET all artists
  artist = Artist.find(params[:id].to_i)
  artist.delete
  redirect to('/artists')
end