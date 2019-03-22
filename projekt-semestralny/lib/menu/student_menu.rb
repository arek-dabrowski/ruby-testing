class StudentMenu
  def self.handle_student_option
    puts `clear`
    puts "Co chcesz zrobić z uczniami?"
    puts "1. Dodaj ucznia"
    puts "2. Usuń ucznia"
    puts "3. Edytuj ucznia"
    puts "4. Przypisz ucznia do przedmiotu"
    puts "0. Cofnij"
    user_input = STDIN.gets[0]
    case user_input
    when '1'
      StudentMenu.add_student
    when '2'
      StudentMenu.delete_student
    when '3'
      StudentMenu.update_student
    when '4'
      StudentMenu.add_student_to_subject
    when '0'
      Menu.show_menu
    else
      puts "Nieprawidłowe dzialanie"
      gets
      Menu.show_menu
    end
  end

  def self.add_student
    puts `clear`
    puts "Dodawanie ucznia"
    puts "Podaj imię"
    first_name = gets.chomp
    while !first_name.match(/([A-Z])\w+/)
      puts "Niepoprawne imię!"
      first_name = gets.chomp
    end
    puts "Podaj nazwisko"
    last_name = gets.chomp
    while !last_name.match(/([A-Z])\w+/)
      puts "Niepoprawne nazwisko!"
      last_name = gets.chomp
    end
    StudentController.insert_student(first_name, last_name)
    puts 'Dodano studenta!'
    gets
    Menu.show_menu
  end

  def self.delete_student
    puts `clear`
    puts "Usuwanie ucznia"

    puts "Którego ucznia usunąć?"
    updated_student = choose_student
    StudentController.delete_student(updated_student)
    puts 'Usunięto studenta!'
    gets
    Menu.show_menu
  end

  def self.update_student
    puts `clear`
    puts "Edycja ucznia"

    puts "Którego ucznia edytować?"
    updated_student = choose_student

    puts "Podaj imię"
    first_name = gets.chomp
    while !first_name.match(/([A-Z])\w+/)
      puts "Niepoprawne imie!"
      first_name = gets.chomp
    end
    puts "Podaj nazwisko"
    last_name = gets.chomp
    while !last_name.match(/([A-Z])\w+/)
      puts "Niepoprawne nazwisko!"
      last_name = gets.chomp
    end
    StudentController.update_student(updated_student, first_name, last_name)
    puts 'Zedytowano studenta!'
    gets
    Menu.show_menu
  end

  def self.add_student_to_subject
    puts `clear`
    puts "Przypisanie ucznia do przedmiotu"

    puts "Którego ucznia przypisać?"
    updated_student = choose_student

    puts "Do którego przedmiotu?"
    updated_subject = SubjectMenu.choose_subject

    StudentController.add_student_to_subject(updated_student, updated_subject)
    puts 'Zapisano studenta na przedmiot!'
    gets
    Menu.show_menu
  end

  def self.delete_student_from_subject
    puts `clear`
    puts "Wypisanie ucznia z przedmiotu"

    puts "Którego ucznia wypisać?"
    updated_student = choose_student
    
    puts "Z którego przedmiotu?"
    updated_subject = SubjectMenu.choose_subject

    StudentController.delete_student_from_subject(updated_student, updated_subject)
    puts 'Wypisano studenta z przedmiotu!'
    gets
    Menu.show_menu
  end

  def self.choose_student
    students = StudentController.get_all_students
    students.each_with_index do |student, index|
      puts index.to_s + " " + student[:first_name] + " " + student[:last_name]
    end
    user_input = gets.chomp
    while !user_input.match(/^(\d)+$/) || students[user_input.to_i].nil?
      puts 'Niepoprawnie wybrano studenta!'
      user_input = gets.chomp
    end
    student = students[user_input.to_i]
    student
  end
end