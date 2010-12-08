module BrighterPlanet
  module Automobile
    module Fallback
      def self.included(base)
        base.falls_back_on  :fuel_efficiency => 20.182.miles_per_gallon.to(:kilometres_per_litre), # mpg https://brighterplanet.sifterapp.com/projects/30/issues/428
                            :urbanity => 0.43, # EPA via Ian https://brighterplanet.sifterapp.com/projects/30/issues/428
                            :annual_distance => 11819.miles.to(:kilometres) # miles https://brighterplanet.sifterapp.com/projects/30/issues/428
      end
    end
  end
end
