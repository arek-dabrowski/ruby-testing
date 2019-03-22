class MarkMenu
    def self.show_mark_menu
        puts `clear`
        puts "Co chcesz zrobić z ocenami?"
        puts "1. Dodaj ocene do ucznia"
        puts "2. Edytuj ocene ucznia"
        puts "3. Usuń ocene ucznia"
        puts "4. Wyświetl wszystkie oceny"
        puts "5. Wyświetl wszystkie oceny danego ucznia z przedmiotu"
        puts "0. Cofnij"
        user_input = STDIN.gets[0]
        case user_input
        when '1'
            MarkMenu.add_mark
        when '2'
            MarkMenu.update_mark
        when '3'
            MarkMenu.delete_mark
        when '4'
            MarkMenu.write_all_marks
        when '5'
            MarkMenu.write_all_marks_from_student_from_subject
        when '0'
            Menu.show_menu
        else
            puts "Nieprawidłowe działanie"
            gets
            Menu.show_menu
        end
    end

    def self.add_mark
        puts `clear`
        puts "Do którego ucznia dodać ocenę?"
        student = StudentMenu.choose_student
        puts `clear`
        puts "Do jakiego przedmiotu dodać ocenę?"
        subject = SubjectMenu.choose_subject
        puts `clear`
        puts "Jaką ocenę dać?"
        user_input = gets.chomp
        while !user_input.match(/^(\d)+$/) || user_input.to_i < 1 || user_input.to_i > 6
            puts "Podano zla liczbe"
            user_input = gets.chomp
        end
        puts `clear`
        puts "Za co dać ocenę?"
        desc = gets.chomp
        MarkController.add_mark_to_student_from_subject(user_input.to_s, desc, student, subject)
        puts 'Dodano ocene!'
        gets
        Menu.show_menu
    end

    def self.update_mark
        puts `clear`
        puts "Którego ucznia ocenę zmienić?"
        student = StudentMenu.choose_student
        puts `clear`
        puts "Z jakiego przedmiotu?"
        subject = SubjectMenu.choose_subject
        puts `clear`
        puts "Ktorą ocenę zmienić?"
        mark = MarkMenu.choose_mark_for_student_for_subject(student, subject)
        puts `clear`
        puts "Na jaka ocenę zmienić?"
        user_input = gets.chomp
        while !user_input.match(/^(\d)+$/) || user_input.to_i < 1 || user_input.to_i > 6
            puts "Podano zla liczbe"
            user_input = gets.chomp
        end
        puts `clear`
        puts "Na jaki opis zmienić?"
        desc = gets.chomp
        MarkController.update_mark(mark, user_input.to_s, desc)
        puts `clear`
        puts "Zmieniono ocenę!"
        gets
        Menu.show_menu
    end

    def self.delete_mark
        puts `clear`
        puts "Którego ucznia ocenę usunąć?"
        student = StudentMenu.choose_student
        puts `clear`
        puts "Z jakiego przedmiotu?"
        subject = SubjectMenu.choose_subject
        puts `clear`
        puts "Którą ocenę usunąć?"
        mark = MarkMenu.choose_mark_for_student_for_subject(student, subject)
        MarkController.delete_mark(mark)
        puts `clear`
        puts "Usunięto ocenę!"
        gets
        Menu.show_menu
    end

    def self.write_all_marks
        marks = MarkController.get_all_marks
        marks.each_with_index do |mark, index|
            puts ("Nr: " + index.to_s + " ocena: " +
                mark[:mark].to_s + " opis: " +
                mark[:desc].to_s + " imie ucznia: " +
                Student[:id => mark[:student_id]][:first_name].to_s + " nazwisko ucznia: " +
                Student[:id => mark[:student_id]][:last_name].to_s + " nazwa przedmiotu: " +
                Subject[:id => mark[:subject_id]][:name])
        end
        gets
        Menu.show_menu
    end

    def self.write_all_marks_from_student_from_subject
        puts `clear`
        puts "Wybierz ucznia"
        student = StudentMenu.choose_student
        puts `clear`
        puts "Wybierz przedmiot"
        subject = SubjectMenu.choose_subject
        marks = Mark.where(:student_id => student[:id]).where(:subject_id => subject[:id]).map.to_a
        marks.each_with_index do |mark, index|
            puts ("Nr: " + index.to_s + " ocena: " +
                mark[:mark].to_s + " opis: " +
                mark[:desc].to_s + " imie ucznia: " +
                Student[:id => mark[:student_id]][:first_name].to_s + " nazwisko ucznia: " +
                Student[:id => mark[:student_id]][:last_name].to_s + " nazwa przedmiotu: " +
                Subject[:id => mark[:subject_id]][:name])
        end
        gets
        Menu.show_menu
    end

    def self.choose_mark_for_student_for_subject student, subject
        marks = Mark.where(:student_id => student[:id]).where(:subject_id => subject[:id]).map.to_a
        marks.each_with_index do |mark, index|
            puts ("Nr: " + index.to_s + " ocena: " +
                mark[:mark].to_s + " opis: " +
                mark[:desc].to_s + " imie ucznia: " +
                Student[:id => mark[:student_id]][:first_name].to_s + " nazwisko ucznia: " +
                Student[:id => mark[:student_id]][:last_name].to_s + " nazwa przedmiotu: " +
                Subject[:id => mark[:subject_id]][:name])
        end
        user_input = gets.chomp
        while !user_input.match(/^(\d)+$/) || (user_input.to_i < 0) || (user_input.to_i > marks.length)
            puts "Podano zlą liczbę!"
            user_input = gets.chomp
        end
        user_input = user_input.to_i
        selected_mark = marks[user_input]
        selected_mark
    end
end