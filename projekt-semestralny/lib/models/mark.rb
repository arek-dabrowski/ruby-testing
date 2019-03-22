require 'sequel'
require 'sqlite3'

class Mark < Sequel::Model
  many_to_one :student
  many_to_one :subject
  plugin :validation_helpers
  def validate
    super
    validates_presence [:mark]
  end
end
