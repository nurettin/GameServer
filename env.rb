require 'sequel'
require 'bcrypt'

Dir['lib/*.rb'].each do |m|
  require_relative m
end

DB = Sequel::Model.db = Sequel.connect('postgres://postgres:123456@localhost/game_server')
Sequel::Model.plugin :schema
Sequel::Model.plugin :timestamps

Dir['models/*.rb'].each do |m|
  require_relative m
end

