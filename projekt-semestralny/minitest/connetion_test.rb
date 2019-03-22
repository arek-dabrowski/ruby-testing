require_relative '../lib/connection'
require 'minitest/autorun'


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

    describe "should connect properly if database exists" do
        it do
            before_conn = File.exist?(@db_path)
            Connection.change_path(@db_path)
            Connection.check_connection
            after_conn = File.exist?(@db_path)
            assert_equal after_conn,before_conn
        end
    end

    describe "should create database if doesn't exists and connect properly" do
        it do
            FileUtils.rm(@db_path)
            before_conn = File.exist?(@db_path)
            Connection.change_path(@db_path)
            Connection.check_connection
            after_conn = File.exist?(@db_path)
            wont_equal after_conn,before_conn
        end
    end

    describe "should create directory and database if doesn't exists and connect properly" do
        it do
            FileUtils.rm(@db_path)
            FileUtils.remove_dir('test_resources')
            before_conn = File.exist?(@db_path)
            Connection.change_path(@db_path)
            Connection.check_connection
            after_conn = File.exist?(@db_path)
            wont_equal after_conn,before_conn
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

        describe "shouldn't connect if given path is nil" do
            it do
                proc{Connection.change_path(nil)}.must_raise ArgumentError
            end
        end

        describe "shouldn't connect if given path is empty string" do
            it do
                proc{Connection.change_path("")}.must_raise ArgumentError
            end
        end

        describe "shouldn't connect if given path is integer" do
            it do
                proc{Connection.change_path(12)}.must_raise ArgumentError
            end
        end

        describe "shouldn't connect if given path is numeric" do
            it do
                proc{Connection.change_path(5.695)}.must_raise ArgumentError
            end
        end

        describe "shouldn't connect if given path is an array" do
            it do
                proc{Connection.change_path(["Masło", "Foo", "Bar"])}.must_raise ArgumentError
            end
        end

        describe "shouldn't connect if given path is boolean" do
            it do
                proc{Connection.change_path(true)}.must_raise ArgumentError
            end
        end

        describe "shouldn't connect if given path is leads to a file with other extension" do
            it do
                proc{Connection.change_path("test_resources/book.pdf")}.must_raise ArgumentError
            end
        end

        describe "shouldn't connect if given path is leads to a directory" do
            it do
                proc{Connection.change_path("test_resources/books")}.must_raise ArgumentError
        end
      end

        describe "shouldn't connect if given path is incorrect" do
            it do
                proc{Connection.change_path("JamesBond007")}.must_raise ArgumentError
            end
        end
    end
  end
