require 'io/console'
require 'sqlite3'
require 'sequel'
require './lib/controllers/mark_controller'
require './lib/controllers/student_controller'
require './lib/controllers/note_controller'
require './lib/controllers/subject_controller'
require './lib/controllers/data_controller'
require './lib/menu/student_menu'
require './lib/menu/note_menu'
require './lib/menu/subject_menu'
require './lib/menu/mark_menu'
require './lib/menu/data_menu'
require './lib/menu/statistic_menu'


class Menu
  def self.show_menu
    puts `clear`
    puts "Dziennik dla ucznia gimnazjum"
    puts "Co chcesz zrobić?"
    puts "1. Zarządzaj uczniami"
    puts "2. Zarządzaj przedmiotami"
    puts "3. Zarządzaj ocenami"
    puts "4. Zarządzaj uwagami"
    puts "5. Statystyki"
    puts "6. Import/Export danych"
    puts "0. Koniec"
    user_input = STDIN.gets[0]
    Menu.handle_menu_input(user_input)
  end


  def self.handle_menu_input input
    case input
    when '1'
      StudentMenu.handle_student_option
    when '2'
      SubjectMenu.handle_subject_option
    when '3'
      MarkMenu.show_mark_menu
    when '4'
      NoteMenu.handle_note_option
    when '5'
      StatisticMenu.show_statistic_menu
    when "6"
      DataMenu.show_data_menu
    when "0"
      Menu.end_program
    else
      puts "Nieprawidlowe dzialanie"
      gets
      Menu.show_menu
    end
  end

  def self.end_program
    puts `clear`
    puts "Koniec"
  end

end
