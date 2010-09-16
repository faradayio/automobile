require 'leap'
require 'conversions'

module BrighterPlanet
  module Automobile
    module CarbonModel
      def self.included(base)
        base.extend ::Leap::Subject
        base.decide :emission, :with => :characteristics do
          committee :emission do # returns kg CO2
            quorum 'from fuel', :needs => [:fuel_consumed, :emission_factor], :appreciates => :fuel_type do |characteristics|
              if characteristics[:fuel_type].andand.code == AutomobileFuelType::CODES[:electricity]
                0.0 # FIXME waiting for fuel_efficiency values in kilometres per kWh from fuel_efficiency
              else
                characteristics[:fuel_consumed] * characteristics[:emission_factor]
              end
            end
            
            quorum 'default' do
              raise "The emission committee's default quorum should never be called"
            end
          end
      
          committee :emission_factor do # returns kilograms CO2 per litre **OR** kilograms CO2 per litre
            quorum 'from fuel type', :needs => :fuel_type do |characteristics|
              characteristics[:fuel_type].emission_factor
            end
      
            quorum 'default' do
              AutomobileFuelType.fallback.emission_factor
            end
          end
          
          committee :fuel_consumed do # returns litres
            quorum 'from adjusted fuel_efficiency and distance', :needs => [:adjusted_fuel_efficiency, :distance] do |characteristics|
              characteristics[:distance] / characteristics[:adjusted_fuel_efficiency]
            end
          end
          
          committee :distance do # returns kilometres
            quorum 'from annual distance', :needs => [:annual_distance, :active_subtimeframe] do |characteristics, timeframe|
              characteristics[:annual_distance] * (characteristics[:active_subtimeframe] / timeframe.year)
            end
          end
          
          committee :annual_distance do # returns kilometres
            quorum 'from annual distance estimate', :needs => :annual_distance_estimate do |characteristics|
              characteristics[:annual_distance_estimate]
            end
      
            quorum 'from weekly distance estimate', :needs => :weekly_distance_estimate do |characteristics, timeframe|
              (characteristics[:weekly_distance_estimate] / 7 ) * timeframe.year.days
            end
            
            quorum 'from daily distance', :needs => :daily_distance do |characteristics, timeframe|
              characteristics[:daily_distance] * timeframe.year.days
            end
            
            quorum 'from size class', :needs => :size_class do |characteristics|
              characteristics[:size_class].annual_distance
            end
      
            quorum 'from fuel type', :needs => :fuel_type do |characteristics|
              characteristics[:fuel_type].annual_distance
            end
            
            quorum 'default' do
              Automobile.automobile_model.fallback.annual_distance_estimate
            end
          end
          
          committee :daily_distance do # returns kilometres
            quorum 'from daily distance estimate', :needs => :daily_distance_estimate do |characteristics|
              characteristics[:daily_distance_estimate]
            end
            
            quorum 'from daily duration', :needs => [:daily_duration, :speed] do |characteristics|
              characteristics[:daily_duration] * characteristics[:speed]
            end
          end
          
          committee :adjusted_fuel_efficiency do # returns kilometres per litre
            quorum 'from fuel efficiency', :needs => :fuel_efficiency do |characteristics|
              characteristics[:fuel_efficiency]
            end
      
            quorum 'from variant', :needs => [:variant, :urbanity] do |characteristics|
              fuel_efficiencies = characteristics[:variant].attributes.symbolize_keys.slice(:fuel_efficiency_city, :fuel_efficiency_highway)
              urbanity = characteristics[:urbanity]
              1.0 / ((urbanity / fuel_efficiencies[:fuel_efficiency_city].to_f) + ((1.0 - urbanity) / fuel_efficiencies[:fuel_efficiency_highway].to_f))
            end
            
            quorum 'from nominal fuel efficiency and multiplier', :needs => [:nominal_fuel_efficiency, :fuel_efficiency_multiplier] do |characteristics|
              characteristics[:nominal_fuel_efficiency] * characteristics[:fuel_efficiency_multiplier]
            end
          end
          
          committee :fuel_efficiency_multiplier do # returns coefficient
            quorum 'from_size_class_and_hybridity', :needs => [:size_class, :hybridity, :urbanity] do |characteristics|
              drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
              urbanity = characteristics[:urbanity]
              size_class = characteristics[:size_class]
              fuel_efficiency_multipliers = {
                :city => size_class.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                :highway => size_class.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
              }
              if fuel_efficiency_multipliers.values.any?(&:nil?)
                nil
              else
                1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
              end
            end
            
            quorum 'from hybridity', :needs => [:hybridity, :urbanity] do |characteristics|
              drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
              urbanity = characteristics[:urbanity]
              fuel_efficiency_multipliers = {
                :city => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                :highway => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
              }
              1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
            end
            
            quorum 'default' do
              1.0
            end
          end
          
          committee :nominal_fuel_efficiency do # returns kilometres per litre **OR** (FIXME) kilometres per kWh
            quorum 'from model', :needs => [:model, :urbanity] do |characteristics|
              fuel_efficiency_city = characteristics[:model].fuel_efficiency_city.to_f
              fuel_efficiency_highway = characteristics[:model].fuel_efficiency_highway.to_f
              urbanity = characteristics[:urbanity]
              1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
            end
      
            quorum 'from make and model year', :needs => [:model_year] do |characteristics|
              characteristics[:model_year].make_year.andand.fuel_efficiency
            end
      
            quorum 'from size class', :needs => [:size_class, :urbanity] do |characteristics|
              fuel_efficiencies = characteristics[:size_class].attributes.symbolize_keys.slice(:fuel_efficiency_city, :fuel_efficiency_highway)
              urbanity = characteristics[:urbanity]
              1.0 / ((urbanity / fuel_efficiencies[:fuel_efficiency_city].to_f) + ((1.0 - urbanity) / fuel_efficiencies[:fuel_efficiency_highway].to_f))
            end
      
            quorum 'from model year', :needs => :model_year do |characteristics|
              characteristics[:model_year].fuel_efficiency
            end
           
            quorum 'from make', :needs => :make do |characteristics|
              characteristics[:make].fuel_efficiency
            end
           
            quorum 'default' do
              Automobile.automobile_model.fallback.fuel_efficiency
            end
          end
          
          committee :speed do # returns kilometres per hour
            quorum 'from urbanity', :needs => :urbanity do |characteristics|
              1 / (characteristics[:urbanity] / ::BrighterPlanet::Automobile::CarbonModel::SPEEDS[:city] + (1 - characteristics[:urbanity]) / ::BrighterPlanet::Automobile::CarbonModel::SPEEDS[:highway]) 
            end
          end
          
          committee :urbanity do
            quorum 'default' do
              Automobile.automobile_model.fallback.urbanity
            end
          end
          
          committee :fuel_type do
            quorum 'from variant', :needs => :variant do |characteristics|
              characteristics[:variant].fuel_type
            end
      
            quorum 'default' do
              Automobile.automobile_model.fallback.fuel_type
            end
          end
          
          committee :active_subtimeframe do
            quorum 'from acquisition and retirement', :needs => [:acquisition, :retirement] do |characteristics, timeframe|
              Timeframe.constrained_new characteristics[:acquisition].to_date, characteristics[:retirement].to_date, timeframe
            end
          end
          
          committee :acquisition do
            quorum 'from model year or year', :appreciates => [:model_year, :year] do |characteristics|
              if characteristics[:model_year]
                Date.new characteristics[:model_year].year, 1, 1
              elsif characteristics[:year]
                Date.new characteristics[:year].to_i, 1, 1
              end
            end
            quorum 'from retirement', :appreciates => :retirement do |characteristics, timeframe|
              [ timeframe.from, characteristics[:retirement] ].compact.min
            end
          end
          
          committee :retirement do
            quorum 'from acquisition', :appreciates => :acquisition do |characteristics, timeframe|
              [ timeframe.to, characteristics[:acquisition] ].compact.max
            end
          end
          
        end
      end
      SPEEDS = {
        :highway => 57.1.miles.to(:kilometres), # https://brighterplanet.sifterapp.com/projects/30/issues/428
        :city => 19.9.miles.to(:kilometres)     # https://brighterplanet.sifterapp.com/projects/30/issues/428
      }
    end
  end
end
