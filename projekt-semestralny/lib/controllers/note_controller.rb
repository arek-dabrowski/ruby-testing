require './lib/models/note'
require './lib/controllers/student_controller'

class NoteController

    def self.get_all_notes
        notes = Note.map.to_a
        notes
    end

    def self.insert_note note_message, student
        StudentController.check_student student, student[:first_name], student[:last_name]
        student = Student.where(:id => student[:id]).first
        check_note note_message
        note = Note.new(:note_message => note_message, :student_id => student[:id])
        note.save
    end

    def self.update_note note, note_message
        if(note == nil)
            raise ArgumentError
        end
        check_note note_message
        note = Note.where(:id => note[:id]).first
        if(note == nil)
            raise ArgumentError
        end
        note[:note_message] = note_message
        note.save
    end

    def self.check_note note_message
        if(note_message == nil || note_message == "")
            raise ArgumentError
        end
        if(!note_message.is_a? String)
            raise ArgumentError
        end
    end
end
