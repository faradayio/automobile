# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

require 'conversions'

## Automobile:carbon model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of an automobile**.
#
##### Timeframe, acquisition, and retirement
# The model estimates the emissions that occur during a particular `timeframe`. To do this it needs to know the automobile's `acquisition` (the date it started being used) and `retirement` (the date it stopped being used). For example, if the `timeframe` is January 2010, an automobile with `acquisition` of January 2009 and `retirement` of February 2010 will have emissions, but an automobile with `acquisition` of February 2010 or `retirement` of December 2009 will not.  If no `timeframe` is specified, the default is the current year. If no `acquisition` is specified, the default is the first day of the `timeframe`, or the `retirement`, whichever is earlier. If no `retirement` is specified, the default is the last day of the `timeframe`, or the `acquisition`, whichever is later.
#
##### Calculations
# The final estimate is the result of the **calculations** detailed below. These calculations are performed in reverse order, starting with the last calculation listed and finishing with the `emission` calculation. Each calculation is named according to the value it returns.
#
##### Methods
# To accomodate varying client input, each calculation may have one or more **methods**. These are listed under each calculation in order from most to least preferred. Each method is named according to the values it requires. If any of these values is not available the method will be ignored. If all the methods for a calculation are ignored, the calculation will not return a value. "Default" methods do not require any values, and so a calculation with a default method will always return a value.
#
##### Standard compliance
# Each method lists any established calculation standards with which it **complies**. When compliance with a standard is requested, all methods that do not comply with that standard are ignored. This means that any values a particular method requires will have been calculated using a compliant method, because those are the only methods available. If any value did not have a compliant method in its calculation then it would be undefined, and the current method would have been ignored.
#
##### Collaboration
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes shold include test coverage for new functionality. Please see [sniff](http://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module Automobile
    module CarbonModel
      def self.included(base)
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate in *kg CO<sub>2</sub>e.
          committee :emission do
            #### Emission from fuel
            # **Complies:**
            #
            # Multiplies `fuel consumed` in *l* by the `emission factor` in *kg CO<sub>2</sub>e / l* to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel', :needs => [:fuel_consumed, :emission_factor], :appreciates => :fuel_type do |characteristics|
              if characteristics[:fuel_type].andand.code == AutomobileFuelType::CODES[:electricity]
                0.0
              else
                characteristics[:fuel_consumed] * characteristics[:emission_factor]
              end
            end
            
            #### Emission from default
            # **Complies:**
            #
            # Displays an error message if the previous method fails.
            quorum 'default' do
              raise "The emission committee's default quorum should never be called"
            end
          end
          
          ### Emission factor calculation
          # Returns the `emission factor` in *kg CO<sub>2</sub>e / l*
          committee :emission_factor do
            #### Emission factor from fuel type
            # **Complies:**
            #
            # Looks up the automobile [fuel type](http://data.brighterplanet.com/fuel_types)'s `emission factor` in *kg CO2e / l*
            quorum 'from fuel type', :needs => :fuel_type do |characteristics|
              characteristics[:fuel_type].emission_factor
            end
            
            #### Default emission factor
            # **Complies:**
            #
            # Uses a default `emission factor` of 2.49 *kg CO<sub>2</sub>e / l*, calculated from [EPA (2010)](http://www.epa.gov/climatechange/emissions/usinventoryreport.html)
            quorum 'default' do
              AutomobileFuelType.fallback.emission_factor
            end
          end
          
          ### Fuel consumed calculation
          # Returns the `fuel consumed` in *l*.
          committee :fuel_consumed do
            #### Fuel consumed from adjusted fuel efficiency and distance
            # **Complies:**
            #
            # Divides the `distance` in *km* by the `fuel efficiency` in *km / l* to give *l*.
            quorum 'from adjusted fuel_efficiency and distance', :needs => [:adjusted_fuel_efficiency, :distance] do |characteristics|
              characteristics[:distance] / characteristics[:adjusted_fuel_efficiency]
            end
          end
          
          ### Distance calculation
          # Returns the `distance` in *km*.
          # This is the distance the automobile travelled during the `active subtimeframe`.
          committee :distance do
            #### Distance from annual distance
            # **Complies:**
            #
            # Multiplies the `annual distance` in *km* by the fraction of the calendar year in which the `timeframe` falls that overlaps with the `active subtimeframe`.
            quorum 'from annual distance', :needs => [:annual_distance, :active_subtimeframe] do |characteristics, timeframe|
              characteristics[:annual_distance] * (characteristics[:active_subtimeframe] / timeframe.year)
            end
          end
          
          ### Annual distance calculation
          # Returns the `annual distance` in *km*.
          # This is the distance the automobile would travel if it were in use for the entire calendar year in which the `timeframe` falls.
          committee :annual_distance do
            #### Annual distance from annual distance estimate
            # **Complies:**
            #
            # Uses the `annual distance estimate` in *km*.
            quorum 'from annual distance estimate', :needs => :annual_distance_estimate do |characteristics|
              characteristics[:annual_distance_estimate]
            end
            
            #### Annual distance from weekly distance estimate
            # **Complies:**
            #
            # Divides the `weekly distance estimate` in *km* by 7 and multiplies by the number of days in calendar year in which the `timeframe` falls.
            quorum 'from weekly distance estimate', :needs => :weekly_distance_estimate do |characteristics, timeframe|
              (characteristics[:weekly_distance_estimate] / 7 ) * timeframe.year.days
            end
            
            #### Annual distance from daily distance
            # **Complies:**
            #
            # Multiplies the `daily distance` in *km* by the number of days in the calendar year in which the `timeframe` falls.
            quorum 'from daily distance', :needs => :daily_distance do |characteristics, timeframe|
              characteristics[:daily_distance] * timeframe.year.days
            end
            
            #### Annual distance from size class
            # **Complies:**
            #
            # Looks up the automobile [size class](http://data.brighterplanet.com/automobile_size_classes)'s `annual distance` in *km*.
            quorum 'from size class', :needs => :size_class do |characteristics|
              characteristics[:size_class].annual_distance
            end
            
            #### Annual distance from fuel type
            # **Complies:**
            #
            # Looks up the [fuel type](http://data.brighterplanet.com/fuel_types)'s `annual distance` in *km*.
            quorum 'from fuel type', :needs => :fuel_type do |characteristics|
              characteristics[:fuel_type].annual_distance
            end
            
            #### Default annual distance
            # **Complies:**
            #
            # Uses an `annual distance` of 19,021 *km*, calculated from total US automobile vehicle miles travelled and number of automobiles.
            quorum 'default' do
              Automobile.automobile_model.fallback.annual_distance_estimate
            end
          end
          
          ### Annual distance estimate calculation
          # Returns the client-input `annual distance estimate` in *km*.
          # This is the distance that the automobile would travel if it were in use for the entire calendar year in which the `timeframe` falls. Note that if either `acquisition` or `retirement` is specified as occuring during this calendar year, `annual distance estimate` will NOT be the same as the total distance the automobile actually travels.
          
          ### Weekly distance estimate calculation
          # Returns the client-input `weekly distance estimate` in *km*.
          # This is the average distance the automobile travels each week.
          
          ### Daily distance calculation
          # Returns the `daily distance` the automobile travels in *km*.
          committee :daily_distance do
            #### Daily distance from daily distance estimate
            # **Complies:**
            #
            # Uses the `daily distance estimate` in *km*.
            quorum 'from daily distance estimate', :needs => :daily_distance_estimate do |characteristics|
              characteristics[:daily_distance_estimate]
            end
            
            #### Daily distance from daily duration
            # **Complies:**
            #
            # Multiplies the `daily duration` in *hours* by the `speed` in *km / hour* to give `daily distance` in *km*.
            quorum 'from daily duration', :needs => [:daily_duration, :speed] do |characteristics|
              characteristics[:daily_duration] * characteristics[:speed]
            end
          end
          
          ### Daily distance estimate calculation
          # Returns the client-input `daily distance estimate` in *km*.
          
          ### Daily duration calculation
          # Returns the client-input `daily duration` in *hours*.
          
          ### Adjusted fuel efficiency calculation
          # Returns the `adjusted fuel efficiency` in *km / l*
          committee :adjusted_fuel_efficiency do
            #### Adjusted fuel efficiency from fuel efficiency
            # **Complies:**
            #
            # Uses the `fuel efficiency` in *km / l*
            quorum 'from fuel efficiency', :needs => :fuel_efficiency do |characteristics|
              characteristics[:fuel_efficiency]
            end
            
            #### Adjusted fuel efficiency from variant
            # **Complies:**
            #
            # * Looks up the city and highway fuel efficiencies of the automobile [variant](http://data.brighterplanet.com/automobile_variants)
            # * Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`
            quorum 'from variant', :needs => [:variant, :urbanity] do |characteristics|
              fuel_efficiencies = characteristics[:variant].attributes.symbolize_keys.slice(:fuel_efficiency_city, :fuel_efficiency_highway)
              urbanity = characteristics[:urbanity]
              1.0 / ((urbanity / fuel_efficiencies[:fuel_efficiency_city].to_f) + ((1.0 - urbanity) / fuel_efficiencies[:fuel_efficiency_highway].to_f))
            end
            
            #### Adjusted fuel efficiency from nominal fuel efficiency and multiplier
            # **Complies:**
            #
            # Multiplies the `nominal fuel efficiency` in *km / l* by the `fuel efficiency multiplier`. This increases the fuel efficiency if the automobile is a hybrid, or decreases it slightly the automobile is conventional.
            quorum 'from nominal fuel efficiency and multiplier', :needs => [:nominal_fuel_efficiency, :fuel_efficiency_multiplier] do |characteristics|
              characteristics[:nominal_fuel_efficiency] * characteristics[:fuel_efficiency_multiplier]
            end
          end
          
          ### Fuel efficiency calculation
          # Returns the client-input `fuel efficiency` in *km / l*.
          
          ### Fuel efficiency multiplier calculation
          # Returns the `fuel efficiency multiplier`. This value may be used to adjust the fuel efficiency based on whether the automobile is conventional or a hybrid.
          committee :fuel_efficiency_multiplier do
            #### Fuel efficiency multiplier from size class and hybridity
            # **Complies:**
            #
            # * Looks up the appropriate city and highway fuel efficiency multipliers for the automobile [size class](http://data.brighterplanet.com/automobile_size_classes)
            # * Calculates the harmonic mean of those multipliers, weighted by `urbanity`
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
            
            #### Fuel efficiency multiplier from size class and hybridity
            # **Complies:**
            #
            # * Looks up the default city and highway fuel efficiency multipliers
            # * Calculates the harmonic mean of those multipliers, weighted by `urbanity`
            quorum 'from hybridity', :needs => [:hybridity, :urbanity] do |characteristics|
              drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
              urbanity = characteristics[:urbanity]
              fuel_efficiency_multipliers = {
                :city => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                :highway => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
              }
              1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
            end
            
            #### Default fuel efficiency multiplier
            # **Complies:**
            #
            # Uses a default `fuel efficiency multiplier` of 1.
            quorum 'default' do
              1.0
            end
          end
          
          ### Hybridity calculation
          # Returns the client-input `hybridity`. This indicates whether the automobile is a hybrid electric vehicle or a conventional vehicle.
          
          ### Nominal fuel efficiency calculation
          # Returns the `nominal fuel efficiency` in *km / l*
          committee :nominal_fuel_efficiency do
            #### Nominal fuel efficiency from model
            # **Complies:**
            #
            # * Looks up the automobile [model](http://data.brighterplanet.com/automobile_models)'s city and highway fuel efficiencies in *km / l*
            # * Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`
            quorum 'from model', :needs => [:model, :urbanity] do |characteristics|
              fuel_efficiency_city = characteristics[:model].fuel_efficiency_city.to_f
              fuel_efficiency_highway = characteristics[:model].fuel_efficiency_highway.to_f
              urbanity = characteristics[:urbanity]
              1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
            end
            
            #### Nominal fuel efficiency from make and model_year
            # **Complies:**
            #
            # * Looks up the automobile [model year](http://data.brighterplanet.com/automobile_model_years)'s `make year`
            # * Looks up that [make year](http://data.brighterplanet.com/automobile_make_years)'s fuel efficiency in *km / l*
            quorum 'from make and model year', :needs => [:model_year] do |characteristics|
              characteristics[:model_year].make_year.andand.fuel_efficiency
            end
            
            #### Nominal fuel efficiency from size class
            # **Complies:**
            #
            # * Looks up the automobile [size class](http://data.brighterplanet.com/automobile_makes)' city and highway fuel efficiency in *km / l*
            # * Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`
            quorum 'from size class', :needs => [:size_class, :urbanity] do |characteristics|
              fuel_efficiencies = characteristics[:size_class].attributes.symbolize_keys.slice(:fuel_efficiency_city, :fuel_efficiency_highway)
              urbanity = characteristics[:urbanity]
              1.0 / ((urbanity / fuel_efficiencies[:fuel_efficiency_city].to_f) + ((1.0 - urbanity) / fuel_efficiencies[:fuel_efficiency_highway].to_f))
            end
            
            #### Nominal fuel efficiency from model year
            # **Complies:**
            #
            # Looks up the automobile [make](http://data.brighterplanet.com/automobile_makes)'s fuel efficiency in *km / l*.
            quorum 'from model year', :needs => :model_year do |characteristics|
              characteristics[:model_year].fuel_efficiency
            end
            
            #### Nominal fuel efficiency from make
            # **Complies:**
            #
            # Looks up the automobile [make](http://data.brighterplanet.com/automobile_makes)'s fuel efficiency in *km / l*.
            quorum 'from make', :needs => :make do |characteristics|
              characteristics[:make].fuel_efficiency
            end
            
            #### Default nominal fuel efficiency
            # **Complies:**
            #
            # Uses a `nominal fuel efficiency` of 8.58 *km / l*, calculated from total US automobile vehicle miles travelled and gasoline and diesel consumption.
            quorum 'default' do
              Automobile.automobile_model.fallback.fuel_efficiency
            end
          end
          
          ### Size class calculation
          # Returns the client-input automobile [size class](http://data.brighterplanet.com/automobile_size_classes).
          
          ### Speed calculation
          # Returns the average `speed` at which the automobile travels in *km / hour*
          committee :speed do
            #### Speed from urbanity
            # **Complies:**
            #
            # * Takes average city and highway driving speeds from [EPA (2006)](http://www.epa.gov/fueleconomy/420r06017.pdf) and converts from *miles / hour* to *km / hour*
            # * Calculates the harmonic mean of those speeds, weighted by `urbanity`
            quorum 'from urbanity', :needs => :urbanity do |characteristics|
              1 / (characteristics[:urbanity] / 19.9.miles.to(:kilometres) + (1 - characteristics[:urbanity]) / 57.1.miles.to(:kilometres)) 
            end
          end
          
          ### Urbanity calculation
          # Returns the `urbanity`.
          # This is the fraction of the total distance driven that occurs on towns and city streets as opposed to highways (defined using a 45 miles per hour "speed cutpoint").
          committee :urbanity do
            #### Urbanity from client input
            # **Complies:** All
            #
            # Uses the client-input `urbanity`.
            
            #### Default urbanity
            # **Complies:**
            #
            # Uses an `urbanity` of 0.43 after [EPA (2009) Appendix A](http://www.epa.gov/otaq/cert/mpg/fetrends/420r09014-appx-a.pdf)
            quorum 'default' do
              Automobile.automobile_model.fallback.urbanity
            end
          end
          
          ### Fuel type calculation
          # Returns the `fuel type` used by the automobile.
          committee :fuel_type do
            #### Fuel type from client input
            # **Complies:** All
            #
            # Uses the client-input [fuel type](http://data.brighterplanet.com/fuel_types).
            
            #### Fuel type from variant
            # **Complies:**
            #
            # Looks up the [variant](http://data.brighterplanet.com/automobile_variants)'s `fuel type`.
            quorum 'from variant', :needs => :variant do |characteristics|
              characteristics[:variant].fuel_type
            end
            
            # Default fuel type
            # **Complies:**
            #
            # Uses an artificial fuel type representing a mix of gasoline and diesel proprtional to the number of gasoline and diesel automobiles in the U.S.
            quorum 'default' do
              Automobile.automobile_model.fallback.fuel_type
            end
          end
          
          ### Active subtimeframe calculation
          # Returns the portion of the `timeframe` that falls between the `acquisition` and `retirement`.
          committee :active_subtimeframe do
            #### Active subtimeframe from timeframe, acquisition, and retirement
            # **Complies:**
            #
            # Uses the portion of the `timeframe` that falls between `acquisition` and `retirement`.
            quorum 'from acquisition and retirement', :needs => [:acquisition, :retirement] do |characteristics, timeframe|
              Timeframe.constrained_new characteristics[:acquisition].to_date, characteristics[:retirement].to_date, timeframe
            end
          end
          
          ### Acquisition calculation
          # Returns the date of the automobile's `acquisition`.
          # This is the date the automobile was put into use.
          committee :acquisition do
            #### Acquisition from client input
            # **Complies:** All
            #
            # Uses the client-input `acquisition`.
            
            #### Acquisition from model year or year
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses the first day of the client-input automobile [model year](http://data.brighterplanet.com/automobile_model_years)'s year, or if no `model year` was specified uses the first day of the client-input `year`.
            quorum 'from model year or year', :appreciates => [:model_year, :year] do |characteristics|
              if characteristics[:model_year]
                Date.new characteristics[:model_year].year, 1, 1
              elsif characteristics[:year]
                Date.new characteristics[:year].to_i, 1, 1
              end
            end
            
            #### Acquisition from timeframe or retirement
            # **Complies:**
            #
            # Uses the first day of the `timeframe`, or the `retirement`, whichever is earlier.
            quorum 'from retirement', :appreciates => :retirement do |characteristics, timeframe|
              [ timeframe.from, characteristics[:retirement] ].compact.min
            end
          end
          
          ### Retirement calculation
          # Returns the date of the automobile's `retirement`.
          # This is the date the automobile was taken out of use.
          committee :retirement do
            #### Retirement from client input
            # **Complies:** All
            #
            # Uses the client-input `retirement`.
            
            #### Retirement from timeframe or acquisition
            # **Complies:**
            #
            # Uses the last day of the `timeframe`, or the `acquisition`, whichever is later.
            quorum 'from acquisition', :appreciates => :acquisition do |characteristics, timeframe|
              [ timeframe.to, characteristics[:acquisition] ].compact.max
            end
          end
          
          ### Variant calculation
          # Returns the client-input automobile [variant](http://data.brighterplanet.com/automobile_variants).
          
          ### Model calculation
          # Returns the client-input automobile [model](http://data.brighterplanet.com/automobile_models).
          
          ### Model year calculation
          # Returns the client-input automobile [model year](http://data.brighterplanet.com/automobile_years).
          
          ### Make calculation
          # Returns the client-input automobile [make](http://data.brighterplanet.com/automobile_makes).
          
          ### Timeframe calculation
          # Returns the `timeframe`.
          # This is the period during which to calculate emissions.
            
            #### Timeframe from client input
            # **Complies:** All
            #
            # Uses the client-input value for `timeframe`.
            
            #### Default timeframe
            # **Complies:** All
            #
            # Uses the current calendar year.
        end
      end
    end
  end
end
