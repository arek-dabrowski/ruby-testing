require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/mark_controller'
require_relative '../lib/models/mark'
require_relative '../lib/models/subject'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/models/student'
require_relative '../lib/controllers/subject_controller'

describe 'Mark' do
  before do
    @DB = Sequel.sqlite('resources/test_db.db')
  end

  describe "add_mark_to_student_from_subject" do
    context "should create mark for given student and subject properly" do
      it "when arguments are valid" do
        count_before = @DB[:marks].count
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te1')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        expect(@DB[:marks].count).to eq(count_before + 1)
      end
      it "when arguments are valid and mark is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te21')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        expect(@DB[:marks].order(:id).last[:mark]).to eq('3')
      end
      it "when arguments are valid and description is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te22')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        expect(@DB[:marks].order(:id).last[:desc]).to eq("spr")
      end
      it "when arguments are valid and student_id is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te25')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        expect(@DB[:marks].order(:id).last[:student_id]).to eq(student[:id])
      end
      it "when arguments are valid and subject_id is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te26')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        expect(@DB[:marks].order(:id).last[:subject_id]).to eq(subject[:id])
      end
    end
  end

  describe "delete_mark" do
    context "should delete mark for given student and subject properly" do
      it "when arguments are valid" do
        count_before = @DB[:marks].count
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te2')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.delete_mark(mark)
        expect(@DB[:marks].count).to eq(count_before)
      end
    end
  end

  describe "update_mark" do
    context "should update mark for given student and subject properly" do
      it "when arguments are valid" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te3')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        expect(@DB[:marks].order(:id).last[:mark]).to eq('4')
      end
      it "when arguments are valid and description is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te23')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "aaa")
        mark = Mark.where(:id => mark[:id]).first
        expect(@DB[:marks].order(:id).last[:desc]).to eq("aaa")
      end
      it "when arguments are valid and student_id is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te24')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        expect(@DB[:marks].order(:id).last[:student_id]).to eq(student[:id])
      end
      it "when arguments are valid and subject_id is proper" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te30')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        expect(@DB[:marks].order(:id).last[:subject_id]).to eq(subject[:id])
      end
    end
  end

  describe "get_all_marks" do
    context "should return all marks properly" do
      it "when argument is valid" do
        marks = MarkController.get_all_marks.length
        number_of_marks = @DB[:marks].count
        expect(marks).to eq(number_of_marks)
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
    context "should raise ArgumentError" do
      it "when arg is nil" do
        arg = nil
        expect {MarkController.is_nil_or_empty(arg)}.to raise_error(ArgumentError)
      end

      it "when arg is an empty string" do
        arg = ""
        expect {MarkController.is_nil_or_empty(arg)}.to raise_error(ArgumentError)
      end
    end
  end

  describe "add_mark_to_student_from_subject" do
    context "should raise ArgumentError" do
      it "when mark is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te4')
        expect {MarkController.add_mark_to_student_from_subject(nil, "spr", student, subject)}.to raise_error(ArgumentError)
      end
      it "when desc is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te5')
        mark = "3"
        expect {MarkController.add_mark_to_student_from_subject(mark, nil, student, subject)}.to raise_error(ArgumentError)
      end
      it "when student is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te6')
        mark = "3"
        expect {MarkController.add_mark_to_student_from_subject(mark, "spr", nil, subject)}.to raise_error(ArgumentError)
      end
      it "when subject is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = StudentController.get_all_students[0]
        subject = Subject.create(:name => 'Te7')
        mark = "3"
        expect {MarkController.add_mark_to_student_from_subject(mark, "spr", student, nil)}.to raise_error(ArgumentError)
      end
    end
  end
  describe "update_mark" do
    context "should raise ArgumentError" do
      it "when mark is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te8')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        expect {MarkController.update_mark(nil, "3", "spr")}.to raise_error(ArgumentError)
      end
      it "when new mark is invalid string" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te12')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        expect {MarkController.update_mark(mark, "3asdad", "spr")}.to raise_error(ArgumentError)
      end

      it "when new mark is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te9')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        expect {MarkController.update_mark(mark, nil, "spr")}.to raise_error(ArgumentError)
      end

      it "when new description is nil" do
        StudentController.insert_student('Gal', 'Anonim')
        student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        subject = Subject.create(:name => 'Te10')
        MarkController.add_mark_to_student_from_subject("3", "spr", student, subject)
        mark = Mark.where(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id]).first
        MarkController.update_mark(mark, "4", "spr")
        mark = Mark.where(:id => mark[:id]).first
        expect {MarkController.update_mark(mark, "3", nil)}.to raise_error(ArgumentError)
      end
    end
  end

  describe "delete_mark" do
    context "should raise ArgumentError" do
      it "when mark is nil" do
        expect {MarkController.delete_mark(nil)}.to raise_error(ArgumentError)
      end
      it "when mark doesn't exist" do
        mark = Mark.new
        expect {MarkController.delete_mark(mark)}.to raise_error(ArgumentError)
      end
      it "when mark is an empty string" do
        mark = Mark.new
        expect {MarkController.delete_mark("")}.to raise_error(ArgumentError)
      end
    end
  end

  describe "is_mark_number" do
    context "should raise ArgumentError" do
      it "when mark is not a string number between 0 and 6" do
        expect {MarkController.is_mark_number("7")}.to raise_error(ArgumentError)
      end
      it "when mark is a float number" do
        expect {MarkController.is_mark_number("3.4")}.to raise_error(ArgumentError)
      end
      it "when mark is a word string" do
        expect {MarkController.is_mark_number("asdaskjdcjkhsDHjsd")}.to raise_error(ArgumentError)
      end
      it "when mark is nil" do
        expect {MarkController.is_mark_number(nil)}.to raise_error(ArgumentError)
      end
    end
  end

  after do
    @DB = nil
  end
end