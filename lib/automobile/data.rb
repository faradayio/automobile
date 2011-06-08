module BrighterPlanet
  module Automobile
    module Data
      def self.included(base)
        base.create_table do
          string   'make_name'
          string   'make_year_name'
          string   'make_model_name'
          string   'make_model_year_name'
          string   'make_model_year_variant_row_hash'
          string   'size_class_name'
          string   'automobile_fuel_name'
          boolean  'hybridity'
          float    'urbanity' # DEPRECATED
          float    'urbanity_estimate'
          float    'speed'
          float    'city_speed'
          float    'highway_speed'
          boolean  'hybridity'
          float    'hybridity_multiplier'
          float    'fuel_efficiency'
          float    'annual_distance'
          float    'weekly_distance'
          float    'daily_distance'
          float    'daily_duration'
          date     'acquisition'
          date     'retirement'
        end
        
        base.data_miner do
          process "pull orphans" do
            AutomobileMakeFleetYear.run_data_miner! # sabshere 5/25/10 i'm not sure we actually need to have this in cm1
          end
        end
      end
    end
  end
end
