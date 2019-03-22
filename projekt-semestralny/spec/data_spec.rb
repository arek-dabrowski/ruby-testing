require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/data_controller'
require_relative '../lib/controllers/mark_controller'
require_relative '../lib/models/mark'
require_relative '../lib/controllers/subject_controller'
require_relative '../lib/models/subject'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/models/student'
require_relative '../lib/controllers/note_controller'
require_relative '../lib/models/note'

describe 'Data' do
    before(:context) do
        @DB = Sequel.sqlite('resources/test_db.db')

        StudentController.insert_student('Ania', 'Nowak')
        StudentController.insert_student('Jan', 'Kowalski')
        StudentController.insert_student('Janina', 'Dziwna')
        StudentController.insert_student('Weird', 'Man')

        SubjectController.insert_subject('Matematyka')
        SubjectController.insert_subject('Informatyka')
        SubjectController.insert_subject('Polski')
        SubjectController.insert_subject('Angielski')

        NoteController.insert_note('Była zła', Student.where(:id => 1).first)
        NoteController.insert_note('Pobił kolegę', Student.where(:id => 2).first)
        NoteController.insert_note('Była niegrzeczna', Student.where(:id => 3).first)
        NoteController.insert_note('Dziwny człowiek', Student.where(:id => 4).first)

        StudentController.add_student_to_subject(Student.where(:id => 1).first, Subject.where(:id => 1).first)
        StudentController.add_student_to_subject(Student.where(:id => 2).first, Subject.where(:id => 2).first)
        StudentController.add_student_to_subject(Student.where(:id => 3).first, Subject.where(:id => 3).first)
        StudentController.add_student_to_subject(Student.where(:id => 4).first, Subject.where(:id => 4).first)

        MarkController.add_mark_to_student_from_subject("3", "spr", Student.where(:id => 1).first, Subject.where(:id => 1).first)
        MarkController.add_mark_to_student_from_subject("4", "praca domowa", Student.where(:id => 2).first, Subject.where(:id => 2).first)
        MarkController.add_mark_to_student_from_subject("2", "odpowiedź", Student.where(:id => 3).first, Subject.where(:id => 3).first)
        MarkController.add_mark_to_student_from_subject("6", "praca klasowa", Student.where(:id => 4).first, Subject.where(:id => 4).first)
    end
    
    describe "export_tables" do
        context "should export data properly" do
            it "when directory /csv doesn't exist" do
                DataController.export_tables
                tables = DB.tables
                count_records = 0
                count_saved_records = 0
                tables.each do |table|
                    filename = 'resources/csv/'
                    filename << table.to_s
                    filename << '.csv'
                    count_records = count_records + DB[table].count
                    line_count = `wc -l "#{filename}"`.strip.split(' ')[0].to_i
                    count_saved_records = count_saved_records + line_count -1
                end
                expect(count_records).to eq(count_saved_records)
            end
            it "when directory /csv already exists" do
                dirname = File.dirname('resources/csv/')
                unless File.directory?(dirname)
                    FileUtils.mkdir_p(dirname)
                end
                DataController.export_tables
                tables = DB.tables
                count_records = 0
                count_saved_records = 0
                tables.each do |table|
                    filename = 'resources/csv/'
                    filename << table.to_s
                    filename << '.csv'
                    count_records = count_records + DB[table].count
                    line_count = `wc -l "#{filename}"`.strip.split(' ')[0].to_i
                    count_saved_records = count_saved_records + line_count -1
                end
                expect(count_records).to eq(count_saved_records)
            end
        end
    end

    describe "import_tables" do
        context "should import data properly" do
            it "when database doesn't contain imported records" do
                DataController.export_tables
                tables = DB.tables
                tables.reverse_each do |table|
                    DB[table].delete
                end
                DataController.import_tables
                count_records = 0
                count_saved_records = 0
                tables.each do |table|
                    filename = 'resources/csv/'
                    filename << table.to_s
                    filename << '.csv'
                    count_records = count_records + DB[table].count
                    line_count = `wc -l "#{filename}"`.strip.split(' ')[0].to_i
                    count_saved_records = count_saved_records + line_count -1
                end
                expect(count_records).to eq(count_saved_records)
            end
        end
    end

    after(:all) do
        if File.directory?('resources/csv')
            FileUtils.rm_rf('resources/csv')
        end
    end

    after(:context) do
        @DB = nil
    end
end

describe 'Data Exceptions' do
    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end

    describe "import_data" do
        context "should raise ArgumentError" do
          it "when all .csv files don't exist" do
            expect {DataController.import_tables}.to raise_error(ArgumentError)
          end
          it "when all .csv files are empty" do
            DataController.export_tables
            tables = DB.tables
            tables.each do |table|
                filename = "resources/csv/"
                filename << table.to_s
                filename << ".csv"
                File.open(filename, 'w') {|file| file.truncate(0) }
            end
            expect {DataController.import_tables}.to raise_error(ArgumentError)
          end
          it "when any of .csv files don't exist" do
            DataController.export_tables
            FileUtils.rm('resources/csv/students.csv')
            expect {DataController.import_tables}.to raise_error(ArgumentError)
          end
          it "when any of .csv files are empty" do
            DataController.export_tables
            tables = DB.tables
            filename = "resources/csv/students.csv"
            File.open(filename, 'w') {|file| file.truncate(0) }
            expect {DataController.import_tables}.to raise_error(ArgumentError)
          end
        end
    end

    after(:all) do
        if File.directory?('resources/csv')
            FileUtils.rm_rf('resources/csv')
        end
    end

    after do
        @DB = nil
    end
end
