module BrighterPlanet
  module Automobile
    module Characterization
      def self.included(base)
        base.characterize do
          has :make
          has :model
          has :year
          has :size_class
          has :automobile_fuel
          has :acquisition
          has :retirement
          has :hybridity
          has :urbanity
          has :speed, :measures => Measurement::BigSpeed
          has :city_speed, :measures => Measurement::BigSpeed
          has :highway_speed, :measures => Measurement::BigSpeed
          has :fuel_efficiency, :measures => Measurement::BigLengthPerVolume
          has :annual_distance, :measures => Measurement::BigLength
          has :weekly_distance, :measures => Measurement::BigLength
          has :daily_distance, :measures => Measurement::BigLength
          has :daily_duration, :measures => :time
        end
      end
    end
  end
end
