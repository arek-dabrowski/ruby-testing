require 'sequel'
require 'sqlite3'

class Student < Sequel::Model
  many_to_many :subjects, join_table: :students_subjects
  one_to_many :notes
  one_to_many :marks
  plugin :validation_helpers
  def validate
    super
    validates_presence [:first_name, :last_name]
    validates_not_null [:first_name, :last_name]
    validates_format /[A-Z]{1}[a-z]+/, [:first_name, :last_name]
  end
end
