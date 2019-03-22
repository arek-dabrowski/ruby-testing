require 'sequel'
require 'sqlite3'

class Subject < Sequel::Model
  many_to_many :students, join_table: :students_subjects
  one_to_many :marks
  plugin :validation_helpers
  def validate
    super
    validates_presence :name
    validates_unique :name
  end

end