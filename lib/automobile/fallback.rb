module BrighterPlanet
  module Automobile
    module Fallback
      def self.included(base)
        base.falls_back_on :urbanity_estimate => 0.43, # EPA via Ian https://brighterplanet.sifterapp.com/projects/30/issues/428
                           :city_speed => 19.9.miles.to(:kilometres),
                           :highway_speed => 57.1.miles.to(:kilometres),
                           :hybridity_multiplier => 1.0,
                           :fuel_efficiency => 20.182.miles_per_gallon.to(:kilometres_per_litre) # mpg https://brighterplanet.sifterapp.com/projects/30/issues/428
      end
    end
  end
end
