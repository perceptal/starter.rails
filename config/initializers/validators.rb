require 'mail'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || value.empty?
      r = true
    else
      begin
        m = Mail::Address.new(value)

        # We must check that value contains a domain and that value is an email address
        r = m.domain && m.address == value
        t = m.__send__(:tree)
        r &&= (t.domain.dot_atom_text.elements.size > 1)
  
      rescue Exception => e   
        r = false
      end
    end
    record.errors.add(attribute, :email, options.merge(:value => value)) unless r
  end
end

class MobilePhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    invalid = value !~ /\A(([0][7][5-9])(\d{8}))\Z/
    
    record.errors.add(attribute, :mobile_phone, options.merge(:value => value)) if invalid
  end
end

class LandlinePhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    invalid = value !~ /\A([0])((([1])(\d{8,9}))|(([2-3])(\d{9})))\Z/
    
    record.errors.add(attribute, :mobile_phone, options.merge(:value => value)) if invalid
  end
end

module ActiveModel::Validations::HelperMethods
  def validates_email(*attrs)
    validates_with EmailValidator, _merge_attributes(attrs)
  end
  
  def validates_mobile_phone(*attrs)
    validates_with MobilePhoneValidator, _merge_attributes(attrs)
  end
  
  def validates_landline_phone(*attrs)
    validates_with LandlinePhoneValidator, _merge_attributes(attrs)
  end
end
