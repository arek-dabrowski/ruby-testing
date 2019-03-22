require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/models/student'
require_relative '../lib/models/subject'
require_relative '../lib/controllers/subject_controller'
require_relative '../lib/controllers/mark_controller'


require 'minitest/autorun'


describe 'StudentTest' do

    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end
  describe "update_student" do
    describe "should update student properly" do
        it do
            StudentController.insert_student('Ania', 'Nowak')
            student = Student.where(:first_name => "Ania").first
            StudentController.update_student(student, "Yurii", "Owsienienko")
            updated_student = Student.where(:first_name => "Yurii").first
            assert_equal"Owsienienko", updated_student[:last_name]
        end
    end
  end
  describe "insert_student" do
    describe "should add student" do
        it "count" do
            count_before = @DB[:students].count
            StudentController.insert_student('Ania', 'Nowak')
            assert_equal (count_before + 1), (@DB[:students].count)
        end
        it "first name properly" do
            StudentController.insert_student('Ania', 'Nowak')
            assert_equal @DB[:students].order(:id).last[:first_name],'Ania'
        end
        it "last name properly" do
            StudentController.insert_student('Ania', 'Nowak')
            assert_equal @DB[:students].order(:id).last[:last_name],'Nowak'
        end
    end
end
describe "delete_student" do
    describe "should delete student properly" do
        it "when id is valid" do
            student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
            count_before = @DB[:students].count
            StudentController.delete_student(student)
            assert_equal(count_before - 1, @DB[:students].count)
        end
    end
    describe "should delete student's marks" do
        it "when id is valid" do
            student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
            subject = Subject.create(:name => 'Aa1')
            mark1 = Mark.create(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id])
            mark2 = Mark.create(:mark => "4", :desc => "spr2", :student_id => student[:id], :subject_id => subject[:id])
            StudentController.delete_student(student)
            assert_equal(@DB[:marks].where(:student_id => student[:id]).count, 0)
        end
    end
    describe "should delete student's notes" do
        it "when id is valid" do
            student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
            note1 = Note.create(:note_message => "Byl niegrzeczny", :student_id => student[:id])
            note2 = Note.create(:note_message => "Przeszkadzal", :student_id => student[:id])
            StudentController.delete_student(student)
            assert_equal(@DB[:notes].where(:student_id => student[:id]).count, 0)
        end
    end
end

    describe "add_student_to_subject" do
        describe "should add student to subject properly" do
            it "when arguments are valid" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.create(:name => 'Język niemiecki')
                count_before = @DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count
                StudentController.add_student_to_subject(student, subject)
                assert_equal @DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count ,count_before + 1
            end
        end
    end

    describe "delete_student_from_subject" do
        describe "should delete student from subject properly" do
            it "when arguments are valid" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.create(:name => 'Biologia')
                student.add_subject(subject)
                count_before = @DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count
                StudentController.delete_student_from_subject(student, subject)
                assert_equal @DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count,count_before - 1
            end
        end
    end
end

describe 'Student Exceptions' do

    describe "insert_student" do
        describe "should raise ArgumentError" do
            it "when student first name is nil" do
                proc{StudentController.insert_student(nil, "Nowak")}.must_raise ArgumentError
            end
            it "when student last name is nil" do
                proc{StudentController.insert_student("Ania", nil)}.must_raise ArgumentError
            end
            it "when student first name isn't valid" do
                proc{StudentController.insert_student("ania", "Nowak")}.must_raise ArgumentError
            end
            it "when student first name isn't valid" do
                proc{StudentController.insert_student(";;;;", "Nowak")}.must_raise ArgumentError
            end
            it "when student first name isn't valid" do
                proc{StudentController.insert_student("ANIA", "Nowak")}.must_raise ArgumentError
            end
            it "when student last name isn't valid" do
                proc{StudentController.insert_student("Ania", "nowak")}.must_raise ArgumentError
            end
            it "when student last name isn't valid" do
                proc{StudentController.insert_student("Ania", ";;;;")}.must_raise ArgumentError
            end
            it "when student last name isn't valid" do
                proc{StudentController.insert_student("Ania", "NOWAK")}.must_raise ArgumentError
            end
        end
    end

    describe "delete_student" do
        describe "should raise ArgumentError" do
            it "when student not exist" do
                student = Student.new
                proc{StudentController.delete_student(student)}.must_raise ArgumentError
            end
        end
    end

    describe "update_student" do
        describe "should raise ArgumentError" do
            it "when student is nil" do
                proc{StudentController.update_student(nil, "Yo", "Ar")}.must_raise ArgumentError
            end

            it "when student not exist" do
                student = Student.new
                proc{StudentController.update_student(student, "nil", "Ar")}.must_raise ArgumentError
            end

            it "when student's first name is nil" do
                student = Student.new
                proc{StudentController.update_student(student, nil, "Ar")}.must_raise ArgumentError
            end

            it "when student's last name is nil" do
                student = Student.new
                proc{StudentController.update_student(student, "Aa", nil)}.must_raise ArgumentError
            end

            it "when student's first name and last name is nil" do
                student = Student.new
                proc{StudentController.update_student(student, nil, nil)}.must_raise ArgumentError
            end

            it "when student's name is empty" do
                student = Student.new
                proc{StudentController.update_student(student, "nil", "Ar")}.must_raise ArgumentError
            end
        end
    end

    describe "add_student_to_subject" do
        describe "should raise ArgumentError" do
            it "when subject not exists" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.new
                proc{StudentController.add_student_to_subject(student, subject)}.must_raise ArgumentError
            end
            it "when student not exists" do
                student = Student.new
                subject = Subject.create(:name => 'Fizyka')
                proc{StudentController.add_student_to_subject(student, subject)}.must_raise ArgumentError
            end
        end
    end

    describe "delete_student_from_subject" do
        describe "should raise ArgumentError" do
            it "when subject not exists" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.new
                proc{StudentController.delete_student_from_subject(student, subject)}.must_raise ArgumentError
            end
            it "when student not exists" do
                student = Student.new
                subject = Subject.create(:name => 'Chemia')
                proc{StudentController.delete_student_from_subject(student, subject)}.must_raise ArgumentError
            end
            it "when student and subject not exists" do
                student = Student.new
                subject = Subject.new
                proc{StudentController.delete_student_from_subject(student, subject)}.must_raise ArgumentError
            end
        end
    end
end