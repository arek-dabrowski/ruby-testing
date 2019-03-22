require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/mark_controller'
require_relative '../lib/models/mark'
require_relative '../lib/models/subject'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/models/student'
require_relative '../lib/controllers/subject_controller'
require 'minitest/autorun'


describe 'MarkTest' do
  before do
    @DB = Sequel.sqlite('resources/test_db.db')
  end

  describe "add_mark_to_student_from_subject" do
    describe "should create mark for given student and subject properly" do
      it "when arguments are valid" do
        count_before = @DB[:marks].count
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te1')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        assert_equal @DB[:marks].count, count_before + 1
      end
      it "when arguments are valid and mark is proper" do
          StudentController.insert_student('Gal', 'Anonim')
          student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
          subject = Subject.create(:name => 'Te123')
          MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
          assert_equal @DB[:marks].order(:id).last[:mark], '3'
      end
      it "when arguments are valid and description is proper" do
          StudentController.insert_student('Gal', 'Anonim')
          student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
          subject = Subject.create(:name => 'Te321')
          MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
          assert_equal @DB[:marks].order(:id).last[:desc], "spr"
      end
      it "when arguments are valid and student_id is proper" do
          StudentController.insert_student('Gal', 'Anonim')
          student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
          subject = Subject.create(:name => 'Te25')
          MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
          assert_equal @DB[:marks].order(:id).last[:student_id], student[:id]
      end
      it "when arguments are valid and subject_id is proper" do
          StudentController.insert_student('Gal', 'Anonim')
          student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
          subject = Subject.create(:name => 'Te26')
          MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
          assert_equal @DB[:marks].order(:id).last[:subject_id], subject[:id]
      end
    end
  end

  describe "delete_mark" do
    describe "should delete mark for given student and subject properly" do
      it "when arguments are valid" do
        count_before = @DB[:marks].count
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te2')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.delete_mark(mark)
        assert_equal @DB[:marks].count, count_before
      end
    end
  end

  describe "update_mark" do
    describe "should update mark for given student and subject properly" do
      it "when arguments are valid" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te3')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        assert_equal mark[:mark],"4"
      end
      it "when arguments are valid and description is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te23')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "aaa")
        mark = Mark.where(:id => mark[:id]).first
        assert_equal @DB[:marks].order(:id).last[:desc], "aaa"
      end
      it "when arguments are valid and student_id is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te24')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        assert_equal @DB[:marks].order(:id).last[:student_id], student[:id]
      end
      it "when arguments are valid and subject_id is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'TestName')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        assert_equal @DB[:marks].order(:id).last[:subject_id], subject[:id]
      end
    end
  end

  describe "get_all_marks" do
    describe "should return all marks properly" do
      it "when arguments are valid" do
        marks = MarkController.get_all_marks.length
        number_of_marks = @DB[:marks].count
        assert_equal marks,number_of_marks
      end
    end
  end

  after do
    @DB = nil
  end
end

describe 'Mark Exceptions' do
  before do
    @DB = Sequel.sqlite('resources/test_database.db')
  end

  describe "is_nil_or_empty" do
    describe "should raiseArgumentError" do
      it "when arg is nil" do
        arg = nil
        proc {MarkController.is_nil_or_empty(arg)}.must_raise ArgumentError
      end
    end

    describe "should raise ArgumentError" do
      it "when arg is an empty string" do
        arg = ""
        proc {MarkController.is_nil_or_empty(arg)}.must_raise ArgumentError
      end
    end
  end

  describe "add_mark_to_student_from_subject" do
    describe "should raise ArgumentError" do
      it "when mark is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te4')
        proc {MarkController.add_mark_to_student_from_subject(nil, "spr", student, subject)}.must_raise ArgumentError
      end
      it "when desc is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te5')
        mark = "3"
        proc {MarkController.add_mark_to_student_from_subject(mark, nil, student, subject)}.must_raise ArgumentError
      end
      it "when student is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te6')
        mark = "3"
        proc {MarkController.add_mark_to_student_from_subject(mark, "spr", nil, subject)}.must_raise ArgumentError
      end
      it "when subject is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te7')
        mark = "3"
        proc {MarkController.add_mark_to_student_from_subject(mark, "spr", student, nil)}.must_raise ArgumentError
      end
    end
  end
  describe "update_mark" do
    describe "should raise ArgumentError" do
      it "when student is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te8')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        proc {MarkController.update_mark(nil, "3", "spr")}.must_raise ArgumentError
      end
      it "when new mark is invalid string" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te12')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        proc {MarkController.update_mark(mark, "3asdad", "spr")}.must_raise ArgumentError
      end
      it "when new mark is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te9')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        proc {MarkController.update_mark(mark, nil, "spr")}.must_raise ArgumentError
      end

      it "when new description is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te10')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        proc {MarkController.update_mark(mark, "3", nil)}.must_raise ArgumentError
    end
  end
end

  describe "delete_mark" do
    describe "should raise ArgumentError" do
      it "when mark is nil" do
        proc {MarkController.delete_mark(nil)}.must_raise ArgumentError
      end
      it "when mark doesn't exist" do
        mark = Mark.new
        proc {MarkController.delete_mark(mark)}.must_raise ArgumentError
      end
      it "when mark is an empty string" do
        proc {MarkController.delete_mark("")}.must_raise ArgumentError
      end
  end
end

  describe "is_mark_number" do
    describe "should raise ArgumentError" do
      it "when mark is not a string number between 0 and 6" do
        proc {MarkController.is_mark_number("7")}.must_raise ArgumentError
      end
      it "when mark is a float number" do
        proc {MarkController.is_mark_number("3.4")}.must_raise ArgumentError
      end
      it "when mark is a word string" do
        proc {MarkController.is_mark_number("asdaskjdcjkhsDHjsd")}.must_raise ArgumentError
      end
      it "when mark is nil" do
          proc {MarkController.is_mark_number(nil)}.must_raise ArgumentError
      end
    end
  end

  after do
    @DB = nil
  end
end
