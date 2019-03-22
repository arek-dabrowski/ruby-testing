require './lib/models/subject'

class SubjectController
  def self.get_all_subjects
    subjects = Subject.map.to_a
    subjects
  end

  def self.insert_subject name
    if checkName name
      subject = Subject.new(:name => name)
      subject.save
    end
  end

  def self.update_subject subject, name
    check_subject subject, name
    subject = Subject.where(:id => subject[:id]).first
    if(subject == nil)
        raise ArgumentError
    end
    subject[:name] = name
    subject.save
  end

  def self.delete_subject subject
    subject = Subject.where(:id => subject[:id]).first
    if subject == nil
        raise ArgumentError
    else
        Subject.where(:id => subject[:id]).delete
    end
  end

  def self.check_subject subject, name
    if(subject == nil)
        raise ArgumentError
    end
    checkName name
  end

  def self.checkName name
    if Subject[{name: name}] || name == "" || name == nil
      raise ArgumentError
    end
    return true
  end

end