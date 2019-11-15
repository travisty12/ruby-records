require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'pry'

DB = PG.connect({:dbname => 'ruby_records_test'})

RSpec.configure do |config|
  config.after(:each) do
    puts "here"
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
  end
end
