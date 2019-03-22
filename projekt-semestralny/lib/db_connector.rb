require 'sqlite3'
require 'sequel'
require './lib/connection.rb'

Connection.check_connection
DB = Sequel.sqlite(Connection.path)