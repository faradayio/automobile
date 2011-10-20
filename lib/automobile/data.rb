module BrighterPlanet
  module Automobile
    module Data
      def self.included(base)
        base.col :make_name
        base.col :make_year_name
        base.col :make_model_name
        base.col :make_model_year_name
        base.col :make_model_year_variant_row_hash
        base.col :size_class_name
        base.col :automobile_fuel_name
        base.col :hybridity, :type => :boolean
        base.col :urbanity, :type => :float
        base.col :speed, :type => :float
        base.col :city_speed, :type => :float
        base.col :highway_speed, :type => :float
        base.col :hybridity, :type => :boolean
        base.col :hybridity_multiplier, :type => :float
        base.col :fuel_efficiency, :type => :float
        base.col :annual_distance, :type => :float
        base.col :weekly_distance, :type => :float
        base.col :daily_distance, :type => :float
        base.col :daily_duration, :type => :float
        base.col :acquisition, :type => :date
        base.col :retirement, :type => :date
        
        base.data_miner do
          process "pull orphans" do
            AutomobileMakeFleetYear.run_data_miner! # sabshere 5/25/10 i'm not sure we actually need to have this in cm1
          end
        end
      end
    end
  end
end