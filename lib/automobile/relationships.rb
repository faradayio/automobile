require 'earth/automobile/automobile_make'
require 'earth/automobile/automobile_model'
require 'earth/automobile/automobile_year'
require 'earth/automobile/automobile_size_class'

module BrighterPlanet
  module Automobile
    module Relationships
      def self.included(target)
        target.belongs_to :make,            :foreign_key => 'make_name',            :class_name => 'AutomobileMake'
        target.belongs_to :model,           :foreign_key => 'model_name',           :class_name => 'AutomobileModel'
        target.belongs_to :year,            :foreign_key => 'year_name',            :class_name => 'AutomobileYear'
        target.belongs_to :size_class,      :foreign_key => 'size_class_name',      :class_name => 'AutomobileSizeClass'
        target.belongs_to :automobile_fuel, :foreign_key => 'automobile_fuel_name'
        target.belongs_to :country,         :foreign_key => 'country_iso_3166_code'
      end
    end
  end
end
