module BrighterPlanet
  module Automobile
    module Characterization
      def self.included(base)
        base.characterize do
          has :make do |make|
            make.reveals :model_year do |model_year|
              model_year.reveals :model, :trumps => :size_class do |model|
                model.reveals :variant, :trumps => :hybridity
              end
            end
          end
          ## sabshere 5/27/10: thought exercise... if we wanted people to send in make=ford&model=taurus&model_year=2006 (of course it would be &naked_model=, but you get the point)
          # has :make do |make|
          #   make.reveals :naked_model_year do |model_year|
          #     model_year.reveals :model, :naked_trumps => :size_class do |model|
          #       model.reveals :naked_variant, :trumps => :hybridity
          #     end
          #   end
          # end
          has :fuel_type
          has :fuel_efficiency, :trumps => [:urbanity, :hybridity], :measures => :length_per_volume
          has :urbanity, :measures => :percentage
          has :hybridity
          has :daily_distance_estimate, :trumps => [:weekly_distance_estimate, :annual_distance_estimate, :daily_duration], :measures => :length #, :weekly_fuel_cost, :annual_fuel_cost]
          has :daily_duration, :trumps => [:annual_distance_estimate, :weekly_distance_estimate, :daily_distance_estimate], :measures => :time #, :weekly_fuel_cost, :annual_fuel_cost]
          has :weekly_distance_estimate, :trumps => [:annual_distance_estimate, :daily_distance_estimate, :daily_duration], :measures => :length #, :weekly_fuel_cost, :annual_fuel_cost]
          has :annual_distance_estimate, :trumps => [:weekly_distance_estimate, :daily_distance_estimate, :daily_duration], :measures => :length #, :weekly_fuel_cost, :annual_fuel_cost]
          has :acquisition
          has :retirement
          has :size_class
          # has :annual_fuel_cost, :trumps => [:annual_distance_estimate, :weekly_distance_estimate, :daily_distance_estimate, :daily_duration, :weekly_fuel_cost], :measures => :cost
          # has :weekly_fuel_cost, :trumps => [:annual_distance_estimate, :weekly_distance_estimate, :daily_distance_estimate, :daily_duration, :annual_fuel_cost], :measures => :cost
        end
      end
    end
  end
end
