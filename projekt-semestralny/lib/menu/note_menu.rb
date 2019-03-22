class NoteMenu
    def self.handle_note_option
      puts `clear`
      puts "Co chcesz zrobić z uwagami?"
      puts "1. Dodaj uwagę"
      puts "2. Edytuj uwagę"
      puts "0. Cofnij"
      user_input = STDIN.gets[0]
      case user_input
      when '1'
        NoteMenu.add_note
      when '2'
        NoteMenu.update_note
      when '0'
        Menu.show_menu
      else
        puts "Nieprawidłowe dzialanie"
        gets
        Menu.show_menu
      end
    end
  
    def self.add_note
      puts `clear`
      puts "Dodawanie uwagi"
      puts "Któremu uczniowi dodać uwagę"
      updated_student = StudentMenu.choose_student
      puts "Wprowadź treść uwagi"
      note_message = gets.chomp
      NoteController.insert_note(note_message, updated_student)
      puts 'Dodano uwagę!'
      gets
      Menu.show_menu
    end
  
    def self.update_note
        puts `clear`
        puts "Edycja uwagi"
        puts "Którą uwagę edytować?"
        updated_note = chooseNote
        puts "Wprowadź treść uwagi"
        note_message = gets.chomp
        NoteController.update_note(updated_note, note_message)
        puts 'Zedytowano uwagę!'
        gets
        Menu.show_menu
    end

    def self.chooseNote
      notes = NoteController.get_all_notes
        notes.each_with_index do |note, index|
            puts index.to_s + " " + note[:note_message] + " " + note[:student_id].to_s
      end
      user_input = gets.chomp
      while !user_input.match(/^(\d)+$/) || notes[user_input.to_i].nil?
        puts 'Niepoprawnie wybrano uwagę!'
        user_input = gets.chomp
      end
      updated_note = notes[user_input.to_i]
      updated_note
    end
  end