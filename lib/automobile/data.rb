require 'data_miner'

module BrighterPlanet
  module Automobile
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            string   'make_id'
            string   'model_id'
            string   'model_year_id'
            string   'variant_id'
            string   'size_class_id'
            string   'fuel_type_id'
            boolean  'hybridity'
            float    'urbanity'
            float    'fuel_efficiency'
            float    'annual_distance_estimate'
            float    'weekly_distance_estimate'
            float    'daily_distance_estimate'
            float    'daily_duration'
            date     'date'
            date     'acquisition'
            date     'retirement'
          end

          process "pull orphans" do
            AutomobileMakeFleetYear.run_data_miner! # sabshere 5/25/10 i'm not sure we actually need to have this in cm1
          end
          
          process "pull dependencies" do
            run_data_miner_on_belongs_to_associations
          end
        end
      end
    end
  end
end
