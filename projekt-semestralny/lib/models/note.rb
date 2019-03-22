require 'sequel'
require 'sqlite3'

class Note < Sequel::Model
    many_to_one :student
    plugin :validation_helpers
    def validate
        super
        validates_presence [:note_message]
      end
end
