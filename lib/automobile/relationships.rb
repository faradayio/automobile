module BrighterPlanet
  module Automobile
    module Relationships
      def self.included(target)
        target.belongs_to :make,                    :class_name => 'AutomobileMake',                 :foreign_key => 'make_name'
        target.belongs_to :make_year,               :class_name => 'AutomobileMakeYear',             :foreign_key => 'make_year_name'
        target.belongs_to :make_model,              :class_name => 'AutomobileMakeModel',            :foreign_key => 'make_model_name'
        target.belongs_to :make_model_year,         :class_name => 'AutomobileMakeModelYear',        :foreign_key => 'make_model_year_name'
        target.belongs_to :make_model_year_variant, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_year_variant_row_hash'
        target.belongs_to :fuel_type,               :class_name => 'AutomobileFuelType',             :foreign_key => 'fuel_type_code'
        target.belongs_to :size_class,              :class_name => 'AutomobileSizeClass'
      end
    end
  end
end
