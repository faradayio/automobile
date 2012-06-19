module BrighterPlanet
  module Automobile
    module Data
      def self.included(base)
        base.col :make_name
        base.col :model_name
        base.col :year_name,       :type => :integer
        base.col :make_model_name
        base.col :make_model_year_name
        base.col :size_class_name
        base.col :automobile_fuel_name
        base.col :country_iso_3166_code
        base.col :acquisition,     :type => :date
        base.col :retirement,      :type => :date
        base.col :hybridity,       :type => :boolean
        base.col :urbanity,        :type => :float
        base.col :speed,           :type => :float
        base.col :daily_duration,  :type => :float
        base.col :daily_distance,  :type => :float
        base.col :weekly_distance, :type => :float
        base.col :annual_distance, :type => :float
        base.col :fuel_efficiency, :type => :float
        base.col :annual_fuel_use, :type => :float
      end
    end
  end
end
