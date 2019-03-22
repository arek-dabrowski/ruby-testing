require_relative '../lib/connection'
Connection.change_path('resources/test_db.db')
require_relative '../lib/db_connector'
require_relative '../lib/controllers/student_controller'
require_relative '../lib/controllers/statistic_controller'
require_relative '../lib/models/student'
require_relative '../lib/models/subject'

describe 'Statistic' do
    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end
    describe "count_average" do
        context "should count average from one subject properly" do
            it "when arguments are valid" do
                student = Student.create(:first_name => 'Frodo', :last_name => 'Bagins')
                subject = Subject.create(:name => 'Kulturoznastwo')
                MarkController.add_mark_to_student_from_subject("5", "za katrkowke",student, subject)
                MarkController.add_mark_to_student_from_subject("5" ,"za test",student, subject)
                average = StatisticController.average_from_one_subject(student, subject)
                expect(average).to eq(5.0)
            end
        end
        context "should count average from all subjects properly" do
            it "when arguments are valid" do
                student = Student.create(:first_name => 'Frodo', :last_name => 'Bagins')
                subject1 = Subject.create(:name => 'WOS')
                subject2 = Subject.create(:name => 'Algebra')
                MarkController.add_mark_to_student_from_subject("5", "za katrkowke",student, subject1)
                MarkController.add_mark_to_student_from_subject("5" ,"za test",student, subject2)
                average = StatisticController.average_from_all_subjects(student)
                expect(average).to eq(5.0)
            end
        end
    end
end
describe 'Statistic Exceptions' do
    before do
        @DB = Sequel.sqlite('resources/test_db.db')
    end
    describe "average_from_one_subject" do
        context "should raise ArgumentError" do
            it "when student is nil" do
                subject = Subject.create(:name => 'Osmiornicooznastwo')
                expect{StatisticController.average_from_one_subject(nil, subject)}.to raise_error(ArgumentError)
            end
            it "when subject is nil" do
                student = Student.create(:first_name => 'Frodo', :last_name => 'Bagins')
                expect{StatisticController.average_from_one_subject(student, nil)}.to raise_error(ArgumentError)
            end
        end
    end
    describe "average_from_all_subjects" do
        context "should raise ArgumentError" do
            it "when student is nil" do
                expect{StatisticController.average_from_all_subjects(nil)}.to raise_error(ArgumentError)
            end
        end
    end
end