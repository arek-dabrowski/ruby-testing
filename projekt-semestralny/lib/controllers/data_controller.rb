class DataController

    def self.export_tables
        tables = DB.tables
        tables.each do |table|
          save_table table
        end
    end

    def self.import_tables
        tables = DB.tables
        check_csv tables
        tables.each do |table|
          load_table table
        end
    end

    def self.save_table table
        myfile = generate_csv_path table
        make_dir myfile
        f = File.new(myfile, 'w')
        col = DB[table].columns
        mycol = String.new
        col.each do |elem|
          mycol = mycol + elem.to_s
          mycol = mycol + ','
        end
        mycol = mycol[0...-1]
        f.write(mycol)
        f.write("\n")
  
        DB[table].all{|row| 
          myrow = String.new
          col = DB[table].columns
          col.each do |elem|
            myrow = myrow + row[elem.to_sym].to_s
            myrow = myrow + ','
          end
          myrow = myrow[0...-1]
          f.write(myrow)
          f.write("\n")
        }
        f.close
      end

      def self.load_table table
        myfile = generate_csv_path table
        make_dir myfile
        File.open(myfile, 'r').each_with_index do |line, index|
            next if index == 0
            line = line.gsub("\n",'')
            params = line.split(',')
            add_record table.to_s, params
        end
      end
  
      def self.make_dir path
        dirname = File.dirname(path)
        unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
        end
      end
  
      def self.check_csv tables
        tables.each do |table|
            myfile = generate_csv_path table
            if(!File.exist?(myfile))
                raise ArgumentError
            end
            if(File.zero?(myfile))
                raise ArgumentError
            end
        end
      end

      def self.add_record table_name, array
        case table_name
        when "students"
            if DB[:students].where(:id => array[0].to_i).empty?
                StudentController.insert_student array[1], array[2]
            end
        when "marks"
            if DB[:marks].where(:id => array[0].to_i).empty?
                params1 = get_row_from_csv "students", array[1]
                params2 = get_row_from_csv "subjects", array[2]
                imported_student = Student.where(:first_name => params1[1], :last_name => params1[2]).last
                imported_subject = Subject.where(:name => params2[1]).last
                MarkController.add_mark_to_student_from_subject array[3], array[4], imported_student, imported_subject 
            end
        when "notes"
            if DB[:notes].where(:id => array[0].to_i).empty?
                params = get_row_from_csv "students", array[2]
                imported_student = Student.where(:first_name => params[1], :last_name => params[2]).last
                NoteController.insert_note array[1], imported_student
            end
        when "students_subjects"
            if DB[:students_subjects].where(:student_id => array[0].to_i, :subject_id => array[1].to_i).empty?
                params1 = get_row_from_csv "students", array[0]
                params2 = get_row_from_csv "subjects", array[1]
                imported_student = Student.where(:first_name => params1[1], :last_name => params1[2]).last
                imported_subject = Subject.where(:name => params2[1]).last
                StudentController.add_student_to_subject imported_student, imported_subject
            end
        when "subjects"
            if DB[:subjects].where(:id => array[0].to_i).empty?
                SubjectController.insert_subject array[1]
            end
        end
      end

      def self.get_row_from_csv tablename, id
        myfile = generate_csv_path tablename
        array = nil
        File.open(myfile, 'r').each_with_index do |line, index|
            next if index == 0
            line = line.gsub("\n",'')
            params = line.split(',')
            if params[0].to_i == id.to_i
                array = params
            end
        end
        array
      end

      def self.generate_csv_path table
        myfile = 'resources/csv/'
        myfile << table.to_s
        myfile << '.csv'
        myfile
      end
end