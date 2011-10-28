module BrighterPlanet
  module Automobile
    module Relationships
      def self.included(target)
        target.belongs_to :make,       :class_name => 'AutomobileMake',       :foreign_key => 'make_name'
        target.belongs_to :model,      :class_name => 'AutomobileModel',      :foreign_key => 'model_name'
        target.belongs_to :year,       :class_name => 'AutomobileYear',       :foreign_key => 'year_name'
        target.belongs_to :size_class, :class_name => 'AutomobileSizeClass',  :foreign_key => 'size_class_name'
        target.belongs_to :automobile_fuel,                                   :foreign_key => 'automobile_fuel_name'
      end
    end
  end
end
