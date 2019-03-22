class SubjectMenu
    def self.handle_subject_option
      puts `clear`
      puts "Co chcesz zrobić z przedmiotami?"
      puts "1. Dodaj przedmiot"
      puts "2. Usuń przedmiot"
      puts "3. Edytuj przedmiot"
      puts "0. Cofnij"
      user_input = STDIN.gets[0]
      case user_input
      when '1'
        SubjectMenu.add_subject
      when '2'
        SubjectMenu.delete_subject
      when '3'
        SubjectMenu.update_subject
      when '0'
        Menu.show_menu
      else
        puts "Nieprawidłowe dzialanie"
        gets
        Menu.show_menu
      end
    end
  
    def self.add_subject
      puts `clear`
      puts "Dodawanie przedmiotu"
      puts "Podaj nazwę"
      name = gets.chomp
      SubjectController.insert_subject(name)
      puts 'Dodano przedmiot!'
      gets
      Menu.show_menu
    end
  
    def self.delete_subject
      puts `clear`
      puts "Usuwanie przedmiotu"

      puts "Który przedmiot usunąć?"
      deleted_subject = choose_subject
      
      SubjectController.delete_subject(deleted_subject)
      puts 'Usunięto przedmiot!'
      gets
      Menu.show_menu
    end
  
    def self.update_subject
      puts `clear`
      puts "Edycja przedmiotu"
    
      puts "Który przedmiot edytować?"
      updated_subject = choose_subject

      puts "Podaj nazwę"
      name = gets.chomp
      SubjectController.update_subject(updated_subject, name)
      puts 'Zedytowano przedmiot!'
      gets
      Menu.show_menu
    end

    def self.choose_subject
      subjects = SubjectController.get_all_subjects
      subjects.each_with_index do |subjects, index|
        puts index.to_s + " " + subjects[:name]
      end

      user_input = gets.chomp
      while !user_input.match(/^(\d)+$/) || subjects[user_input.to_i].nil?
        puts 'Niepoprawnie wybrano przedmiot!'
        user_input = gets.chomp
      end
      subject = subjects[user_input.to_i]
      subject
    end
  end