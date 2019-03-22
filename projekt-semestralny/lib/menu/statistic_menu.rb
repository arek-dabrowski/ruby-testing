require './lib/controllers/statistic_controller'


class StatisticMenu
  def self.show_statistic_menu
    puts `clear`
    puts "Co chcesz zrobić ze statystykami?"
    puts "1. Wyświetl średnią wszystkich ocen ucznia"
    puts "2. Wyświetl średnią ucznia z wybranego przedmiotu"
    puts "0. Cofnij"

    user_input = STDIN.gets[0]
    case user_input
    when '1'
        StatisticMenu.show_average_from_all_subjects
    when '2'
        StatisticMenu.show_average_from_one_subject
    when '0'
        Menu.show_menu
    else
        puts "Nieprawidłowe dzialanie"
        gets
        Menu.show_menu
    end
  end

  def self.show_average_from_all_subjects
      puts `clear`
      puts "Wybierz ucznia, którego średnią chcesz sprawdzić"
      student = StudentMenu.choose_student
      puts `clear`
      puts StatisticController.average_from_all_subjects(student)
      gets
      Menu.show_menu
  end

  def self.show_average_from_one_subject
      puts `clear`
      puts "Wybierz ucznia, którego średnią chcesz sprawdzić"
      student = StudentMenu.choose_student
      puts `clear`
      puts "Wybierz przedmiot!"
      subject = SubjectMenu.choose_subject
      puts `clear`
      puts StatisticController.average_from_one_subject(student, subject)
      gets
      Menu.show_menu
  end
end
