require 'active_record'
require 'falls_back_on'
require 'automobile'
require 'sniff'

class AutomobileRecord < ActiveRecord::Base
  class << self
    def n
      new :make => AutomobileMake.find_by_name('Nissan')
    end

    def add_implicit_characteristics
      decisions[:emission].committees.map(&:name).reject { |c| characteristics.keys.unshift(:emission).include? c }.each do |c|
        characterize { has c }
      end
    end
  end

  include BrighterPlanet::Automobile
  include Sniff::Emitter
  
  belongs_to :make,                    :class_name => 'AutomobileMake',                 :foreign_key => 'make_name'
  belongs_to :make_year,               :class_name => 'AutomobileMakeYear',             :foreign_key => 'make_year_name'
  belongs_to :make_model,              :class_name => 'AutomobileMakeModel',            :foreign_key => 'make_model_name'
  belongs_to :make_model_year,         :class_name => 'AutomobileMakeModelYear',        :foreign_key => 'make_model_year_name'
  belongs_to :make_model_year_variant, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_year_variant_row_hash'
  belongs_to :fuel_type,               :class_name => 'AutomobileFuelType',             :foreign_key => 'fuel_type_code'
  belongs_to :size_class,              :class_name => 'AutomobileSizeClass'
  
  falls_back_on :fuel_efficiency => 20.182.miles_per_gallon.to(:kilometres_per_litre), # mpg https://brighterplanet.sifterapp.com/projects/30/issues/428
                :urbanity => 0.43, # EPA via Ian https://brighterplanet.sifterapp.com/projects/30/issues/428
                :annual_distance_estimate => 11819.miles.to(:kilometres) # miles https://brighterplanet.sifterapp.com/projects/30/issues/428
end
