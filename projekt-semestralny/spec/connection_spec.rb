require_relative '../lib/connection'

describe 'Connection' do
    before do
        @db_path = 'test_resources/test_db.db'

        dirname = File.dirname(@db_path)
        unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
        end

        FileUtils.cp('resources/test_database.db', 'test_resources/')
        File.rename('test_resources/test_database.db', @db_path)
    end

    describe "check_connection" do
        context "should connect properly" do
            it "when database exists" do
                before_conn = File.exist?(@db_path)
                Connection.change_path(@db_path)
                Connection.check_connection
                after_conn = File.exist?(@db_path)
                expect(before_conn).to eq(after_conn)
            end
            it "when database doesn't exists" do
                FileUtils.rm(@db_path)
                before_conn = File.exist?(@db_path)
                Connection.change_path(@db_path)
                Connection.check_connection            
                after_conn = File.exist?(@db_path)
                expect(before_conn).not_to eq(after_conn)
            end
            it "when directory and database doesn't exists" do
                FileUtils.rm(@db_path)
                FileUtils.remove_dir('test_resources')
                before_conn = File.exist?(@db_path)
                Connection.change_path(@db_path)
                Connection.check_connection  
                after_conn = File.exist?(@db_path)
                expect(before_conn).not_to eq(after_conn)
            end
        end
    end

    after do
        FileUtils.rm(@db_path)
        @db_path = nil
        FileUtils.remove_dir('test_resources')
    end

end

describe 'Connection Exceptions' do

    describe "change_path" do

        context "should raise ArgumentError" do
            it "when given path is nil" do
                expect{Connection.change_path(nil)}.to raise_error(ArgumentError)
            end
            it "when given path is empty string" do
                expect{Connection.change_path("")}.to raise_error(ArgumentError)
            end
            it "when given path is integer" do
                expect{Connection.change_path(12)}.to raise_error(ArgumentError)
            end
            it "when given path is numeric" do
                expect{Connection.change_path(5.695)}.to raise_error(ArgumentError)
            end
            it "when given path is an array" do
                expect{Connection.change_path(["Masło", "Foo", "Bar"])}.to raise_error(ArgumentError)
            end
            it "when given path is boolean" do
                expect{Connection.change_path(true)}.to raise_error(ArgumentError)
            end
            it "when given path leads to a file with other extension than .d" do
                expect{Connection.change_path("test_resources/book.pdf")}.to raise_error(ArgumentError)
            end
            it "when given path leads to a directory" do
                expect{Connection.change_path("test_resources/books")}.to raise_error(ArgumentError)
            end
            it "when given path is incorrect" do
                expect{Connection.change_path("JamesBond007")}.to raise_error(ArgumentError)
            end
        end

    end

end