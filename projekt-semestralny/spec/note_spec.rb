require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/note_controller'
require_relative '../lib/models/note'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/models/student'

describe 'Note' do
    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end
    
    describe "update_note" do
        context "should update note properly" do
            it "when arguments are valid" do
                StudentController.insert_student('Gal', 'Anonim')
                student = Student.where(:first_name => "Gal", :last_name => "Anonim").last
                NoteController.insert_note('Gal nie napisał kroniki', student)
                note = Note.where(:note_message => "Gal nie napisał kroniki", :student_id => student[:id]).first
                NoteController.update_note(note, "Gal był niegrzeczny")
                updated_note = Note.where(:id => note[:id]).first
                expect(updated_note[:note_message]).to eq("Gal był niegrzeczny")
            end
            it "when arguments are valid and student_id is proper" do
                StudentController.insert_student('Gal', 'Anonim')
                student = Student.where(:first_name => "Gal", :last_name => "Anonim").last
                NoteController.insert_note('Gal nie napisał kroniki', student)
                note = Note.where(:note_message => "Gal nie napisał kroniki", :student_id => student[:id]).first
                NoteController.update_note(note, "Gal był niegrzeczny")
                updated_note = Note.where(:id => note[:id]).first
                expect(@DB[:notes].order(:id).last[:student_id]).to eq(student[:id])
            end
        end
    end

    describe "insert_note" do
        context "should add note properly" do
            it "when arguments are valid" do
                StudentController.insert_student('Gal', 'Anonim')
                student = Student.where(:first_name => "Gal", :last_name => "Anonim").last
                count_before = @DB[:notes].count
                NoteController.insert_note('Gal nie napisał kroniki', student)
                expect(@DB[:notes].count).to eq(count_before + 1)
            end
            it "when arguments are valid and student_id is proper" do
                StudentController.insert_student('Gal', 'Anonim')
                student = Student.where(:first_name => "Gal", :last_name => "Anonim").last
                count_before = @DB[:notes].count
                NoteController.insert_note('Gal nie napisał kroniki', student)
                expect(@DB[:notes].order(:id).last[:student_id]).to eq(student[:id])
            end
        end
    end

    describe "get_all_notes" do
        context "should return all notes properly" do
            it "when arguments are valid" do
                notes = NoteController.get_all_notes.length
                number_of_notes = @DB[:notes].count
                expect(notes).to eq(number_of_notes)
            end
        end
    end

    after do
        @DB = nil
    end
end

describe 'Note Exceptions' do
    before do
        @DB = Sequel.sqlite('resources/test_database.db')
        StudentController.insert_student('Gal', 'Anonim')
        @student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
        @note = Note.where(:id => 1).first
    end

    describe "insert_note" do
        context "should raise ArgumentError" do
            it "when note message is nil" do
                expect{NoteController.insert_note(nil, @student)}.to raise_error(ArgumentError)
            end
            it "when note message is empty string" do
                expect{NoteController.insert_note("", @student)}.to raise_error(ArgumentError)
            end
            it "when note message is an integer" do
                expect{NoteController.insert_note(3, @student)}.to raise_error(ArgumentError)
            end
            it "when note message is numeric" do
                expect{NoteController.insert_note(32.54, @student)}.to raise_error(ArgumentError)
            end
            it "when note message is an array" do
                expect{NoteController.insert_note(["Masło", "Foo", "Bar"], @student)}.to raise_error(ArgumentError)
            end
            it "when note message is boolean" do
                expect{NoteController.insert_note(false, @student)}.to raise_error(ArgumentError)
            end
            it "when student doesn't exists" do
                student = Student.new
                expect{NoteController.insert_note("Proper note message", student)}.to raise_error(ArgumentError)
            end
        end
    end

    describe "update_note" do
        context "should raise ArgumentError" do
            it "when note is nil" do
                expect{NoteController.update_note(nil, "Foo")}.to raise_error(ArgumentError)
            end
            it "when note doesn't exists" do
                note = Note.new
                expect{NoteController.update_note(note, "Foo")}.to raise_error(ArgumentError)
            end
            it "when note message is nil" do
                expect{NoteController.update_note(@note, nil)}.to raise_error(ArgumentError)
            end
            it "when note message is empty string" do
                expect{NoteController.update_note(@note, "")}.to raise_error(ArgumentError)
            end
            it "when note message is an integer" do
                expect{NoteController.update_note(@note, 3)}.to raise_error(ArgumentError)
            end
            it "when note message is numeric" do
                expect{NoteController.update_note(@note, 13.2)}.to raise_error(ArgumentError)
            end
            it "when note message is an array" do
                expect{NoteController.update_note(@note, ["Masło", "Foo", "Bar"])}.to raise_error(ArgumentError)
            end
            it "when note message is boolean" do
                expect{NoteController.update_note(@note, true)}.to raise_error(ArgumentError)
            end
        end
    end

    after do
        @DB = nil
        @student = nil
        @note = nil
    end
end
