require './lib/models/student'
require './lib/models/subject'
require './lib/models/mark'



class StatisticController
  def self.average_from_all_subjects student
      if student == nil || student == ""
          raise ArgumentError
      end
      average = Mark.where(:student_id => student[:id]).avg(:mark)
      return average
  end
  def self.average_from_one_subject student, subject
      if student == nil || student == ""
          raise ArgumentError
      end
      if subject == nil || subject == ""
          raise ArgumentError
      end
      average = Mark.where(:student_id => student[:id],:subject_id => subject[:id]).avg(:mark)
      return average
  end
end
