module Lookup
  extend ActiveSupport::Concern
  included do
    def lookup(array, item)
      if !item.nil?
        array.push item if !array.include? item
      end
      array
    end
    
    def lookup_display(array, item)
      if array.nil? || item.nil?
        ""
      else
        array.detect { |a| a.include?(item) }[0]
      end
    end
  end
end