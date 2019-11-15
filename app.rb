#!/usr/bin/ruby

require 'sinatra'
require 'sinatra/reloader'
require './lib/album'
require './lib/song'
require 'pry'
require 'pg'
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "ruby_records"})

get('/') do
  "This route is the default"
end

get('/test') do
  @something = "this is a variable"
  erb(:whatever)
end

get('/albums') do
  @albums = Album.all
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/:id/songs/:song_id') do #get the detail for a specific song -- lyrics, writers, etc
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

get('/custom_route') do
  "We can even create custom routes, but we should only do this when needed."
end

post('/albums/:id/songs') do #post a new song, rerout to the album view
  @album = Album.find(params[:id].to_i())
  song = Song.new({:name => params[:song_name], :album_id => @album.id, :id => nil})
  song.save()
  erb(:album)
end

post('/albums') do
  name = params[:album_name]
  album = Album.new({:name => name, :id => nil})
  album.save()
  @albums = Album.all
  erb(:albums)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
end

patch('/albums/:id/songs/:song_id') do #edit a song and then route back to the album view.
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

delete('/albums/:id') do #delete an album
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

delete('/albums/:id/songs/:song_id') do #delete a song, route back to album view
  song = Song.find(params[:song_id].to_i())
  song.delete()
  @album = Album.find(params[:id].to_i())
  erb(:album)
end
