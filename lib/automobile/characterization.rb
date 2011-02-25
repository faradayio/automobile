module BrighterPlanet
  module Automobile
    module Characterization
      def self.included(base)
        base.characterize do
          has :make
          has :make_year
          has :make_model
          has :make_model_year
          has :make_model_year_variant
          ## sabshere 5/27/10: thought exercise... if we wanted people to send in make=ford&model=taurus&model_year=2006 (of course it would be &naked_model=, but you get the point)
          # has :make do |make|
          #   make.reveals :naked_model_year do |model_year|
          #     model_year.reveals :model, :naked_trumps => :size_class do |model|
          #       model.reveals :naked_variant, :trumps => :hybridity
          #     end
          #   end
          # end
          has :size_class
          has :automobile_fuel
          has :urbanity # DEPRECATED
          has :urbanity_estimate
          has :hybridity
          has :hybridity_multiplier
          has :speed
          has :city_speed
          has :highway_speed
          has :fuel_efficiency
          has :annual_distance
          has :weekly_distance
          has :daily_distance
          has :daily_duration
          has :acquisition
          has :retirement
          # has :annual_fuel_cost, :trumps => [:annual_distance_estimate, :weekly_distance_estimate, :daily_distance_estimate, :daily_duration, :weekly_fuel_cost], :measures => :cost
          # has :weekly_fuel_cost, :trumps => [:annual_distance_estimate, :weekly_distance_estimate, :daily_distance_estimate, :daily_duration, :annual_fuel_cost], :measures => :cost
        end
      end
    end
  end
end
