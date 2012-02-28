module Securable
  extend ActiveSupport::Concern
  included do
    attr_accessible :security_key

    # Validations
    validates_presence_of :low_security_key, :high_security_key
    
    def security_key=(range)
      if range != nil
        self.low_security_key = range.begin
        self.high_security_key = range.end
      end
    end

    def security_key
      (low_security_key..high_security_key)
    end
  end
end