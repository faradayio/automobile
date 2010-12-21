module BrighterPlanet
  module Automobile
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            string   'make_name'
            string   'make_year_name'
            string   'make_model_name'
            string   'make_model_year_name'
            string   'make_model_year_variant_row_hash'
            string   'size_class_name'
            string   'fuel_type_code'
            float    'urbanity'
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

          process "pull orphans" do
            AutomobileMakeFleetYear.run_data_miner! # sabshere 5/25/10 i'm not sure we actually need to have this in cm1
          end
          
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
