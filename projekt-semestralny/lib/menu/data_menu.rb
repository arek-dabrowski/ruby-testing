class DataMenu
    def self.show_data_menu
      puts `clear`
      puts "Co chcesz zrobić z danymi?"
      puts "1. Zapisz dane do pliku .csv"
      puts "2. Wczytaj dane z pliku .csv"
      puts "0. Cofnij"
      user_input = STDIN.gets[0]
      case user_input
      when '1'
        DataMenu.save_data_to_csv
      when '2'
        DataMenu.load_data_from_csv
      when '0'
        Menu.show_menu
      else
        puts "Nieprawidłowe dzialanie"
        gets
        Menu.show_menu
      end
    end
  
    def self.save_data_to_csv
      puts `clear`
      puts "Eksport danych"
      DataController.export_tables
      puts 'Zapisano wszystkie tabele!'
      puts 'Pliki .csv znajdują się w folderze resources'
      gets
      Menu.show_menu
    end

    def self.load_data_from_csv
      puts `clear`
      puts "Import danych"
      DataController.import_tables
      puts 'Wczytano wszystkie tabele!'
      gets
      Menu.show_menu
    end
  
    def self.choose_table
      tables = DB.tables
      tables.each_with_index do |table, index|
        puts index.to_s + " " + table.to_s
      end
      user_input = gets.chomp.to_i
      table = tables[user_input]
      table
    end

    
  end