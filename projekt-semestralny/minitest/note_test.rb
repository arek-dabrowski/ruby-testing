require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/note_controller'
require_relative '../lib/models/note'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/models/student'
require 'minitest/autorun'


describe 'NoteTest' do

    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end

  describe "update_note" do
    describe "should update note properly" do
        it "when arguments are valid" do
            StudentController.insert_student('Gal', 'Anonim')
            student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
            NoteController.insert_note('Gal nie napisał kroniki', student)
            note = Note.where(:note_message => "Gal nie napisał kroniki", :student_id => student[:id]).first
            NoteController.update_note(note, "Gal był niegrzeczny")
            updated_note = Note.where(:id => note[:id]).first
            assert_equal"Gal był niegrzeczny",updated_note[:note_message]
        end
        it "when arguments are valid and student_id is proper" do
            StudentController.insert_student('Gal', 'Anonim')
            student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
            NoteController.insert_note('Gal nie napisał kroniki', student)
            note = Note.where(:note_message => "Gal nie napisał kroniki", :student_id => student[:id]).first
            NoteController.update_note(note, "Gal był niegrzeczny")
            updated_note = Note.where(:id => note[:id]).first
            assert_equal(student[:id],@DB[:notes].order(:id).last[:student_id])
        end
    end
  end

describe "insert_note" do
    describe "should add note properly" do
        it "when arguments are valid" do
            StudentController.insert_student('Gal', 'Anonim')
            student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
            count_before = @DB[:notes].count
            NoteController.insert_note('Gal nie napisał kroniki', student)
            assert_equal((count_before + 1),@DB[:notes].count)
        end
        it "when arguments are valid and student_id is proper" do
            StudentController.insert_student('Gal', 'Anonim')
            student = Student.where(:first_name => "Gal", :last_name => "Anonim").first
            count_before = @DB[:notes].count
            NoteController.insert_note('Gal nie napisał kroniki', student)
            assert_equal(student[:id],@DB[:notes].order(:id).last[:student_id])
        end
    end
  end
  describe "get_all_notes" do
      describe "should return all notes properly" do
            it "when arguments are valid" do
              notes = NoteController.get_all_notes.length
              number_of_notes = @DB[:notes].count
              assert_equal number_of_notes,notes
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
        describe "should raise ArgumentError" do
            it "when note message is nil" do
                proc{NoteController.insert_note(nil, @student)}.must_raise ArgumentError
            end
            it "when note message is empty string" do
                proc{NoteController.insert_note("", @student)}.must_raise ArgumentError
            end
            it "when note message is an integer" do
                proc{NoteController.insert_note(3, @student)}.must_raise ArgumentError
            end
            it "when note message is numeric" do
                proc{NoteController.insert_note(32.54, @student)}.must_raise ArgumentError
            end
            it "when note message is an array" do
                proc{NoteController.insert_note(["Masło", "Foo", "Bar"], @student)}.must_raise ArgumentError
            end
            it "when note message is boolean" do
                proc{NoteController.insert_note(false, @student)}.must_raise ArgumentError
            end
            it "when student doesn't exists" do
                student = Student.new
                proc{NoteController.insert_note("Proper note message", student)}.must_raise ArgumentError
            end
        end
    end

    describe "update_note" do
        describe "should raise ArgumentError" do
            it "when note is nil" do
                proc{NoteController.update_note(nil, "Foo")}.must_raise ArgumentError
            end
            it "when note doesn't exists" do
                note = Note.new
                proc{NoteController.update_note(note, "nil")}.must_raise ArgumentError
            end
            it "when note message is nil" do
                proc{NoteController.update_note(@note, nil)}.must_raise ArgumentError
            end
            it "when note message is empty string" do
                proc{NoteController.update_note(@note, "")}.must_raise ArgumentError
            end
            it "when note message is an integer" do
                proc{NoteController.update_note(@note, 3)}.must_raise ArgumentError
            end
            it "when note message is numeric" do
                proc{NoteController.update_note(@note, 32.54)}.must_raise ArgumentError
            end
            it "when note message is an array" do
                proc{NoteController.update_note(@note, ["Masło", "Foo", "Bar"])}.must_raise ArgumentError
            end
            it "when note message is boolean" do
                proc{NoteController.update_note(@note, false)}.must_raise ArgumentError
            end

        end
    end

    after do
        @DB = nil
        @student = nil
        @note = nil
    end
end
