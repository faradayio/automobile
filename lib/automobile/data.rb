module BrighterPlanet
  module Automobile
    module Data
      def self.included(base)
        base.col :make_name
        base.col :model_name
        base.col :year_name
        base.col :size_class_name
        base.col :automobile_fuel_name
        base.col :acquisition,          :type => :date
        base.col :retirement,           :type => :date
        base.col :hybridity,            :type => :boolean
        base.col :urbanity,             :type => :float
        base.col :speed,                :type => :float
        base.col :city_speed,           :type => :float
        base.col :highway_speed,        :type => :float
        base.col :fuel_efficiency,      :type => :float
        base.col :annual_distance,      :type => :float
        base.col :weekly_distance,      :type => :float
        base.col :daily_distance,       :type => :float
        base.col :daily_duration,       :type => :float
      end
    end
  end
end