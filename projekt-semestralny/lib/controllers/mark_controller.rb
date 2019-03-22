require './lib/models/mark'
require './lib/controllers/student_controller'
require './lib/controllers/subject_controller'

class MarkController

  def self.get_all_marks
    marks = Mark.map.to_a
    marks
  end

  def self.add_mark_to_student_from_subject mark, desc, student, subject
    check_add_mark mark, desc, student, subject
    found_student = Student.where(:id => student[:id]).first
    is_nil_or_empty(found_student)

    found_subject = Subject.where(:id => subject[:id]).first
    is_nil_or_empty(found_subject)

    mark = Mark.new(:mark => mark, :desc => desc, :student_id => found_student[:id], :subject_id => found_subject[:id])
    mark.save
  end

  def self.update_mark mark, new_mark, desc
    check_update_mark(mark, new_mark, desc)
    updated_mark = Mark.where(:id => mark[:id]).first
    updated_mark[:mark] = new_mark.to_s
    updated_mark[:desc] = desc.to_s
    updated_mark.save
  end

  def self.delete_mark mark
    is_nil_or_empty(mark)
    deleted_mark = Mark.where(:id => mark[:id]).first
    is_nil_or_empty(deleted_mark)
    deleted_mark.delete
  end

  def self.check_add_mark mark, desc, student, subject
      is_nil_or_empty(mark)
      is_nil_or_empty(desc)
      is_nil_or_empty(student)
      is_nil_or_empty(subject)
      is_mark_number(mark)
  end

  def self.check_update_mark mark, new_mark, desc
    is_nil_or_empty(mark)
    is_nil_or_empty(new_mark)
    is_nil_or_empty(desc)
    is_mark_number(new_mark)
  end

  def self.is_nil_or_empty arg
    if arg == nil || arg == ""
      raise ArgumentError
    end
  end

  def self.is_mark_number mark
    is_nil_or_empty(mark)
    unless mark.match(/^(\d)+$/)
      raise ArgumentError
    end
    if mark.to_i < 1 || mark.to_i > 6
      raise ArgumentError
    end
  end

end