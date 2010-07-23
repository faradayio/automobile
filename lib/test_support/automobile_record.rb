require 'automobile'

class AutomobileRecord < ActiveRecord::Base
  include BrighterPlanet::Automobile
  include Emitter
  include ActionView::Helpers::NumberHelper
  
  belongs_to :variant,    :class_name => 'AutomobileVariant'
  belongs_to :make,       :class_name => 'AutomobileMake'
  belongs_to :model,      :class_name => 'AutomobileModel'
  belongs_to :model_year, :class_name => 'AutomobileModelYear'
  belongs_to :fuel_type,  :class_name => 'AutomobileFuelType'
  belongs_to :size_class, :class_name => 'AutomobileSizeClass'
  
  falls_back_on :fuel_efficiency => 20.182.miles_per_gallon.to(:kilometres_per_litre), # mpg https://brighterplanet.sifterapp.com/projects/30/issues/428
                :urbanity => 0.43, # EPA via Ian https://brighterplanet.sifterapp.com/projects/30/issues/428
                :annual_distance_estimate => 11819.miles.to(:kilometres) # miles https://brighterplanet.sifterapp.com/projects/30/issues/428
  
  def self.n
    new :make => AutomobileMake.find_by_name('Nissan')
  end
end
