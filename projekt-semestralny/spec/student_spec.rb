require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/models/student'
require_relative '../lib/models/subject'

describe 'Student' do
    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end

    describe "update_student" do
        context "should update student properly" do
            it "when arguments are valid" do
                StudentController.insert_student('Ania', 'Nowak')
                student = Student.where(:first_name => "Ania").first
                StudentController.update_student(student, "Yurii", "Owsienienko")
                updated_student = Student.where(:first_name => "Yurii").first
                expect(updated_student[:last_name]).to eq("Owsienienko")
            end
        end
    end

    describe "insert_student" do
        context "should add student" do
            it "when arguments are valid" do
                count_before = @DB[:students].count
                StudentController.insert_student('Ania', 'Nowak')
                expect(@DB[:students].count).to eq(count_before + 1)
            end
            it "when arguments are valid and first name is proper" do
                StudentController.insert_student('Ania', 'Nowak')
                expect(@DB[:students].order(:id).last[:first_name]).to eq('Ania')
            end
            it "when arguments are valid and last name is proper" do
                StudentController.insert_student('Ania', 'Nowak')
                expect(@DB[:students].order(:id).last[:last_name]).to eq('Nowak')
            end
        end
    end

    describe "delete_student" do
        context "should delete student properly" do
            it "when id is valid" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                count_before = @DB[:students].count
                StudentController.delete_student(student)
                expect(@DB[:students].count).to eq(count_before - 1)
            end
        end
        context "should delete student's marks" do
            it "when id is valid" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.create(:name => 'Aa1')
                mark1 = Mark.create(:mark => "3", :desc => "spr", :student_id => student[:id], :subject_id => subject[:id])
                mark2 = Mark.create(:mark => "4", :desc => "spr2", :student_id => student[:id], :subject_id => subject[:id])
                StudentController.delete_student(student)
                expect(@DB[:marks].where(:student_id => student[:id]).count).to eq(0)
            end
        end
        context "should delete student's notes" do
            it "when id is valid" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                note1 = Note.create(:note_message => "Byl niegrzeczny", :student_id => student[:id])
                note2 = Note.create(:note_message => "Przeszkadzal", :student_id => student[:id])
                StudentController.delete_student(student)
                expect(@DB[:notes].where(:student_id => student[:id]).count).to eq(0)
            end
        end
    end

    describe "add_student_to_subject" do
        context "should add student to subject properly" do
            it "when arguments are valid" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.create(:name => 'Język hiszpanski')
                count_before = @DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count
                StudentController.add_student_to_subject(student, subject)
                expect(@DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count).to eq(count_before + 1)
            end
        end
    end

    describe "delete_student_from_subject" do
        context "should delete student from subject properly" do
            it "when arguments are valid" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.create(:name => 'Biologia')
                student.add_subject(subject)
                count_before = @DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count
                StudentController.delete_student_from_subject(student, subject)
                expect(@DB[:students_subjects].where(:student_id => student[:id], :subject_id => subject[:id]).count).to eq(count_before - 1)
            end
        end
    end
end

describe 'Student Exceptions' do

    describe "insert_student" do
        context "should raise ArgumentError" do
            it "when student first name is nil" do
                expect{StudentController.insert_student(nil, "Nowak")}.to raise_error(ArgumentError)
            end
            it "when student last name is nil" do
                expect{StudentController.insert_student("Ania", nil)}.to raise_error(ArgumentError)
            end
            it "when student first name isn't valid" do
                expect{StudentController.insert_student("ania", "Nowak")}.to raise_error(ArgumentError)
            end
            it "when student first name isn't valid" do
                expect{StudentController.insert_student(";;;;", "Nowak")}.to raise_error(ArgumentError)
            end
            it "when student first name isn't valid" do
                expect{StudentController.insert_student("ANIA", "Nowak")}.to raise_error(ArgumentError)
            end
            it "when student last name isn't valid" do
                expect{StudentController.insert_student("Ania", "nowak")}.to raise_error(ArgumentError)
            end
            it "when student last name isn't valid" do
                expect{StudentController.insert_student("Ania", ";;;;")}.to raise_error(ArgumentError)
            end
            it "when student last name isn't valid" do
                expect{StudentController.insert_student("Ania", "NOWAK")}.to raise_error(ArgumentError)
            end
        end
    end

    describe "delete_student" do
        context "should raise ArgumentError" do
            it "when student doesn't exist" do
                student = Student.new
                expect{StudentController.delete_student(student)}.to raise_error(ArgumentError)
            end
        end
    end

    describe "update_student" do
        context "should raise ArgumentError" do
            it "when student is nil" do
                expect{StudentController.update_student(nil, "Yo", "Ar")}.to raise_error(ArgumentError)
            end

            it "when student doesn't exist" do
                student = Student.new
                expect{StudentController.update_student(student, "nil", "Ar")}.to raise_error(ArgumentError)
            end

            it "when student's first name is nil" do
                student = Student.new
                expect{StudentController.update_student(student, nil, "Ar")}.to raise_error(ArgumentError)
            end

            it "when student's last name is nil" do
                student = Student.new
                expect{StudentController.update_student(student, "Aa", nil)}.to raise_error(ArgumentError)
            end

            it "when student's first name and last name is nil" do
                student = Student.new
                expect{StudentController.update_student(student, nil, nil)}.to raise_error(ArgumentError)
            end

            it "when student's name is empty" do
                student = Student.new
                expect{StudentController.update_student(student, "nil", "Ar")}.to raise_error(ArgumentError)
            end
        end
    end

    describe "add_student_to_subject" do
        context "should raise ArgumentError" do
            it "when subject doesn't exists" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.new
                expect{StudentController.add_student_to_subject(student, subject)}.to raise_error(ArgumentError)
            end
            it "when student doesn't exists" do
                student = Student.new
                subject = Subject.create(:name => 'Fizyka')
                expect{StudentController.add_student_to_subject(student, subject)}.to raise_error(ArgumentError)
            end
        end
    end

    describe "delete_student_from_subject" do
        context "should raise ArgumentError" do
            it "when subject doesn't exists" do
                student = Student.create(:first_name => 'Janusz', :last_name => 'Kowalski')
                subject = Subject.new
                expect{StudentController.delete_student_from_subject(student, subject)}.to raise_error(ArgumentError)
            end
            it "when student doesn't exists" do
                student = Student.new
                subject = Subject.create(:name => 'Chemia')
                expect{StudentController.delete_student_from_subject(student, subject)}.to raise_error(ArgumentError)
            end
            it "when student and subject doesn't exists" do
                student = Student.new
                subject = Subject.new
                expect{StudentController.delete_student_from_subject(student, subject)}.to raise_error(ArgumentError)
            end
        end
    end

end
