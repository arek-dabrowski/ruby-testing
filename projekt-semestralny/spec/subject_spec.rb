require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/subject_controller'
require_relative '../lib/models/subject'

describe 'Subject' do
    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end

    describe "update_subject" do
        context "should update subject properly" do
            it "when arguments are valid" do
                SubjectController.insert_subject('Test1')
                subject = Subject.where(:name => "Test1").first
                SubjectController.update_subject(subject, "Test2")
                updated_subject = Subject.where(:name => "Test2").first
                expect(updated_subject[:name]).to eq("Test2")
            end
        end
    end

    describe "insert_subject" do
        context "should add subject properly" do
            it "when arguments are valid" do
                count_before = @DB[:subjects].count
                SubjectController.insert_subject('Test3')
                expect(@DB[:subjects].count).to eq(count_before + 1)
            end
            it "when arguments are valid and name is proper" do
                SubjectController.insert_subject('Test9')
                expect(@DB[:subjects].order(:id).last[:name]).to eq('Test9')
            end
        end
    end

    describe "delete_subject" do
        context "should delete subject properly" do
            it "when id is valid" do
                subject = Subject.create(:name => 'Test4')
                count_before = @DB[:subjects].count
                SubjectController.delete_subject(subject)
                expect(@DB[:subjects].count).to eq(count_before - 1)
            end
        end
    end

    describe "get_all_subjects" do
        context "should return all subjects properly" do
          it "when arguments are valid" do
            subjects = SubjectController.get_all_subjects.length
            number_of_subjects = @DB[:subjects].count
            expect(subjects).to eq(number_of_subjects)
          end
        end
    end
end

describe 'Subject Exceptions' do
    before do
        @DB = Sequel.sqlite('resources/test_database.db')
    end

    describe "delete_subject" do
        context "should raise ArgumentError" do
            it "when subject doesn't exist" do
                subject = Subject.new
                expect{SubjectController.delete_subject(subject)}.to raise_error(ArgumentError)
            end
        end
    end

    describe "update_subject" do
        context "should raise ArgumentError" do
            it "when subject name is nil" do
                expect{SubjectController.update_subject(nil, "Test5")}.to raise_error(ArgumentError)
            end

            it "when subject doesn't exists" do
                subject = Subject.new
                expect{SubjectController.update_subject(subject, "Test6")}.to raise_error(ArgumentError)
            end

            it "when subject name is nil" do
                subject = Subject.new
                expect{SubjectController.update_subject(subject, nil)}.to raise_error(ArgumentError)
            end

            it "when subject name is empty" do
                subject = Subject.new
                expect{SubjectController.update_subject(subject, "")}.to raise_error(ArgumentError)
            end
        end
    end


    describe "insert_subject" do
        context "should raise ArgumentError" do
            it "when subject name is not unique" do
                SubjectController.insert_subject('Test7')
                expect{SubjectController.insert_subject('Test7')}.to raise_error(ArgumentError)
            end

            it "when subject name is empty" do
                expect{SubjectController.insert_subject("")}.to raise_error(ArgumentError)
            end

            it "when subject name is nil" do
                expect{SubjectController.insert_subject(nil)}.to raise_error(ArgumentError)
            end
        end
    end

    after do
        @DB = nil
    end
end