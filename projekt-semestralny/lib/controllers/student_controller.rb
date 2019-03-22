require './lib/models/student'

class StudentController
    def self.update_student student, first_name, last_name
        check_student student, first_name, last_name
        student = Student.where(:id => student[:id]).first
        if(student == nil)
            raise ArgumentError
        end
        student[:first_name] = first_name
        student[:last_name] = last_name
        student.save
    end

    def self.get_all_students
        students = Student.map.to_a
        students
    end

    def self.insert_student first_name, last_name
        student = Student.new(:first_name => first_name, :last_name => last_name)
        if !student.valid?
            raise ArgumentError
        else
            student.save
        end
    end

    def self.delete_student student
        student = Student.where(:id => student[:id]).first
        if student == nil
            raise ArgumentError
        else
            Student.where(:id => student[:id]).delete
        end
    end

    def self.check_student student, first_name, last_name
        if(student == nil || first_name == nil || last_name == nil || first_name == "" || last_name == "")
            raise ArgumentError
        end
    end

    def self.add_student_to_subject updated_student, updated_subject
        student = Student.where(:id => updated_student[:id]).first
        if(student == nil)
            raise ArgumentError
        end
        subject = Subject.where(:id => updated_subject[:id]).first
        if(subject == nil)
            raise ArgumentError
        end

        student.add_subject(subject)
        student.save
    end

    def self.delete_student_from_subject updated_student, updated_subject
        student = Student.where(:id => updated_student[:id]).first
        if(student == nil)
            raise ArgumentError
        end
        subject = Subject.where(:id => updated_subject[:id]).first
        if(subject == nil)
            raise ArgumentError
        end

        student.remove_subject(subject)
        student.save
    end
end