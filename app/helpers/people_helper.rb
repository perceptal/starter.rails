module PeopleHelper
  def phone(number)
    if number.nil? || number.empty?
      raw "<em>not recorded</em>"
    else
      number
    end
  end
  
  def locked(user)
    "locked" if !user.nil? && user.is_locked
  end
  
  def full_name(person)
    if person.nil?
       ""
    else
       person.full_name
    end
  end
end