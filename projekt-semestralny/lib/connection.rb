require 'fileutils'
require 'sqlite3'
require 'sequel'

class Connection

    @@path = 'resources/test_database.db'

    def self.path
        @@path
    end

    def self.change_path given_path
        check_path given_path
        @@path = given_path
    end

    def self.check_connection
        dirname = File.dirname(@@path)
        unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
        end

        if(!File.exist?(@@path))
            @DB = Sequel.sqlite(@@path)
            Connection.init_database_with_tables
        else
            @DB = Sequel.sqlite(@@path)
        end

    end

    def self.init_database_with_tables

        @DB.create_table(:students) do
            primary_key :id
            String :first_name
            String :last_name
        end

        @DB.create_table(:subjects) do
            primary_key :id
            String :name
        end

        @DB.create_table(:notes) do
            primary_key :id
            String :note_message
            foreign_key :student_id, :students, :on_delete=>:cascade
        end

        @DB.create_table(:students_subjects) do
            foreign_key :student_id, :students, :on_delete=>:cascade
            foreign_key :subject_id, :subjects, :on_delete=>:cascade
        end

        @DB.create_table(:marks) do
            primary_key :id
            foreign_key :student_id, :students, :on_delete=>:cascade
            foreign_key :subject_id, :subjects, :on_delete=>:cascade
            String :mark
            String :desc
        end

    end

    def self.check_path path
        if(path == nil || path == "")
            raise ArgumentError
        end
        if(!path.is_a? String)
            raise ArgumentError
        end
        if(!path.match(/^([a-z_\-\s0-9\.]+)(\/[a-z_\-\s0-9\.]+)+\.(db)$/))
            raise ArgumentError
        end
    end
  end
