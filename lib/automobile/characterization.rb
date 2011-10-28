module BrighterPlanet
  module Automobile
    module Characterization
      def self.included(base)
        base.characterize do
          has :make
          has :model
          has :year
          has :size_class
          has :automobile_fuel # can't call this 'fuel' or else sniff thinks it refers to Fuel not AutomobileFuel
          has :acquisition
          has :retirement
          has :hybridity
          has :urbanity
          has :speed,           :measures => Measurement::BigSpeed
          has :daily_duration,  :measures => :time
          has :daily_distance,  :measures => Measurement::BigLength
          has :weekly_distance, :measures => Measurement::BigLength
          has :annual_distance, :measures => Measurement::BigLength
          has :fuel_efficiency, :measures => Measurement::BigLengthPerVolume
          has :fuel_use,        :measures => Measurement::Volume
        end
      end
    end
  end
end
