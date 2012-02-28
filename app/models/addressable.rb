module Addressable
  extend ActiveSupport::Concern
  included do
    attr_accessible :address_line_1, :address_line_2, :address_locality, :address_area, :address_country, :address_postcode

    def address
      if !address_line_1.nil? && address_line_1.length > 0
        "#{address_line_1}, #{address_locality} #{address_postcode}"
      else
        "no recorded address"
      end
    end
  end
end