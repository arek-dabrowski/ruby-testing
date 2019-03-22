require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/subject_controller'
require_relative '../lib/models/subject'
require 'minitest/autorun'


describe 'Subject' do
    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end

    describe "update_subject" do
        describe "should update subject properly" do
            it "when arguments are valid" do
                SubjectController.insert_subject('Test1')
                subject = Subject.where(:name => "Test1").first
                SubjectController.update_subject(subject, "Test2")
                updated_subject = Subject.where(:name => "Test2").first
                assert_equal updated_subject[:name],"Test2"
            end
        end
    end

    describe "insert_subject" do
        describe "should add subject" do
            it "count" do
                count_before = @DB[:subjects].count
                SubjectController.insert_subject('Test3')
                assert_equal @DB[:subjects].count,count_before + 1
            end
            it "name properly" do
                SubjectController.insert_subject('Test9')
                assert_equal @DB[:subjects].order(:id).last[:name],'Test9'
            end
        end
    end

    describe "delete_subject" do
        describe "should delete subject properly" do
            it "when id is valid" do
                subject = Subject.create(:name => 'Test4')
                count_before = @DB[:subjects].count
                SubjectController.delete_subject(subject)
                assert_equal @DB[:subjects].count, count_before - 1
            end
        end
    end

    describe "get_all_subjects" do
        describe "should return all subjects properly" do
          it "when arguments are valid" do
            subjects = SubjectController.get_all_subjects.length
            number_of_subjects = @DB[:subjects].count
            assert_equal subjects, number_of_subjects
          end
        end
    end
end

describe 'Subject Exceptions' do
    before do
        @DB = Sequel.sqlite('resources/test_database.db')
    end

    describe "delete_subject" do
        describe "should raise ArgumentError" do
            it "when subject not exist" do
                subject = Subject.new
                proc{SubjectController.delete_subject(subject)}.must_raise ArgumentError
            end
        end
    end

    describe "update_subject" do
        describe "should raise ArgumentError" do
            it "when subject name is nil" do
                proc{SubjectController.update_subject(nil, "Test5")}.must_raise ArgumentError
            end

            it "when subject not exists" do
                subject = Subject.new
                proc{SubjectController.update_subject(subject, "Test6")}.must_raise ArgumentError
            end

            it "when subject name is nil" do
                subject = Subject.new
                proc{SubjectController.update_subject(subject, nil)}.must_raise ArgumentError
            end

            it "when subject name is empty" do
                subject = Subject.new
                proc{SubjectController.update_subject(subject, "")}.must_raise ArgumentError
            end
        end
    end


    describe "insert_subject" do
        describe "should raise ArgumentError" do
            it "when subject name is not unique" do
                SubjectController.insert_subject('Test7')
                proc{SubjectController.insert_subject('Test7')}.must_raise ArgumentError
            end

            it "when subject name is empty" do
                proc{SubjectController.insert_subject("")}.must_raise ArgumentError
            end

            it "when subject name is nil" do
                proc{SubjectController.insert_subject(nil)}.must_raise ArgumentError
            end
        end
    end

    after do
        @DB = nil
    end
end
