# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

require 'conversions'

## Automobile carbon model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of an automobile**.
#
##### Timeframe, acquisition, and retirement
# The model estimates the emissions that occur during a particular `timeframe`. To do this it needs to know the automobile's `acquisition` (the date it started being used) and `retirement` (the date it stopped being used). For example, if the `timeframe` is January 2010, an automobile with `acquisition` of January 2009 and `retirement` of February 2010 will have emissions, but an automobile with `acquisition` of February 2010 or `retirement` of December 2009 will not.
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
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](http://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module Automobile
    module CarbonModel
      def self.included(base)
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*).
          committee :emission do
            #### Emission from fuel
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Multiplies `fuel consumed` (*l*) by the `emission factor` (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel', :needs => [:fuel_consumed, :emission_factor], :appreciates => :fuel_type, :complies => [:ghg_protocol, :iso] do |characteristics|
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
          # Returns the `emission factor` (*kg CO<sub>2</sub>e / l*)
          committee :emission_factor do
            #### Emission factor from fuel type
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Looks up the automobile [fuel type](http://data.brighterplanet.com/fuel_types) `emission factor` (*kg CO2e / l*)
            quorum 'from fuel type', :needs => :fuel_type, :complies => [:ghg_protocol, :iso] do |characteristics|
              characteristics[:fuel_type].emission_factor
            end
            
            #### Default emission factor
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses a default `emission factor` of 2.49 *kg CO<sub>2</sub>e / l*, calculated from [EPA (2010)](http://www.epa.gov/climatechange/emissions/usinventoryreport.html)
            quorum 'default', :complies => [:ghg_protocol, :iso] do
              AutomobileFuelType.fallback.emission_factor
            end
          end
          
          ### Fuel consumed calculation
          # Returns the `fuel consumed` (*l*).
          committee :fuel_consumed do
            #### Fuel consumed from fuel efficiency and distance
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Divides the `distance` (*km*) by the `fuel efficiency` (*km / l*) to give *l*.
            quorum 'from fuel efficiency and distance', :needs => [:fuel_efficiency, :distance], :complies => [:ghg_protocol, :iso] do |characteristics|
              characteristics[:distance] / characteristics[:fuel_efficiency]
            end
          end
          
          ### Distance calculation
          # Returns the `distance` (*km*).
          # This is the distance the automobile travelled during the `active subtimeframe`.
          committee :distance do
            #### Distance from annual distance
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Multiplies the `annual distance` (*km*) by the fraction of the calendar year in which the `timeframe` falls that overlaps with the `active subtimeframe`.
            quorum 'from annual distance', :needs => [:annual_distance, :active_subtimeframe], :complies => [:ghg_protocol, :iso] do |characteristics, timeframe|
              characteristics[:annual_distance] * (characteristics[:active_subtimeframe] / timeframe.year)
            end
          end
          
          ### Annual distance calculation
          # Returns the `annual distance` (*km*).
          # This is the distance the automobile would travel if it were in use for the entire calendar year in which the `timeframe` falls.
          # Note that if either `acquisition` or `retirement` occurs during the calendar year in which the `timeframe` falls then `annual distance` will be MORE THAN the distance the automobile actually travelled during that calendar year.
          committee :annual_distance do
            #### Annual distance from client input
            # **Complies:** All
            #
            # Uses the client-input `annual distance` (*km*).
            
            #### Annual distance from weekly distance and timeframe
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Divides the `weekly distance` (*km*) by 7 and multiplies by the number of days in the calendar year in which the `timeframe` falls.
            quorum 'from weekly distance and timeframe', :needs => :weekly_distance, :complies => [:ghg_protocol, :iso] do |characteristics, timeframe|
              (characteristics[:weekly_distance] / 7 ) * timeframe.year.days
            end
            
            #### Annual distance from daily distance and timeframe
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Multiplies the `daily distance` (*km*) by the number of days in the calendar year in which the `timeframe` falls.
            quorum 'from daily distance and timeframe', :needs => :daily_distance, :complies => [:ghg_protocol, :iso] do |characteristics, timeframe|
              characteristics[:daily_distance] * timeframe.year.days
            end
            
            #### Annual distance from daily duration and speed
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Multiplies the `daily duration` (*hours*) by the `speed` (*km / hour*) to give *km*
            # * Multiplies the result by the number of days in the calendar year in which the `timeframe` falls.
            quorum 'from daily duration, speed, and timeframe', :needs => [:daily_duration, :speed], :complies => [:ghg_protocol, :iso] do |characteristics, timeframe|
              characteristics[:daily_duration] * characteristics[:speed] * timeframe.year.days
            end
            
            #### Annual distance from size class
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Looks up the automobile [size class](http://data.brighterplanet.com/automobile_size_classes) `annual distance` (*km*).
            quorum 'from size class', :needs => :size_class, :complies => [:ghg_protocol, :iso] do |characteristics|
              characteristics[:size_class].annual_distance
            end
            
            #### Annual distance from fuel type
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Looks up the [fuel type](http://data.brighterplanet.com/fuel_types) `annual distance` (*km*).
            quorum 'from fuel type', :needs => :fuel_type, :complies => [:ghg_protocol, :iso] do |characteristics|
              characteristics[:fuel_type].annual_distance
            end
            
            #### Default annual distance
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses an `annual distance` of 19,021 *km*, calculated from total US automobile vehicle miles travelled and number of automobiles.
            quorum 'default', :complies => [:ghg_protocol, :iso] do
              base.fallback.annual_distance
            end
          end
          
          ### Weekly distance calculation
          # Returns the client-input `weekly distance` (*km*).
          # This is the average distance the automobile travels each week.
          
          ### Daily distance calculation
          # Returns the client-input `daily distance` (*km*).
          # This is the average distance the automobile travels each day.
          
          ### Daily duration calculation
          # Returns the client-input `daily duration` (*hours*).
          
          ### Fuel efficiency calculation
          # Returns the `fuel efficiency` (*km / l*)
          committee :fuel_efficiency do
            #### Fuel efficiency from client input
            # **Complies:** All
            #
            # Uses the client-input `fuel efficiency` (*km / l*).
            
            #### Fuel efficiency from make model year variant and urbanity
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the city and highway fuel efficiencies of the automobile [make model year variant](http://data.brighterplanet.com/automobile_variants) (*km / l*)
            # * Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`
            quorum 'from make model year variant and urbanity', :needs => [:make_model_year_variant, :urbanity], :complies => [:ghg_protocol, :iso] do |characteristics|
              fuel_efficiency_city = characteristics[:make_model_year_variant].fuel_efficiency_city
              fuel_efficiency_highway = characteristics[:make_model_year_variant].fuel_efficiency_highway
              urbanity = characteristics[:urbanity]
              if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
              end
            end
            
            #### Fuel efficiency from make model year and urbanity
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the city and highway fuel efficiencies of the automobile [make model year](http://data.brighterplanet.com/automobile_model_years) (*km / l*)
            # * Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`
            quorum 'from make model year and urbanity', :needs => [:make_model_year, :urbanity], :complies => [:ghg_protocol, :iso] do |characteristics|
              fuel_efficiency_city = characteristics[:make_model_year].fuel_efficiency_city
              fuel_efficiency_highway = characteristics[:make_model_year].fuel_efficiency_highway
              urbanity = characteristics[:urbanity]
              if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
              end
            end
            
            #### Fuel efficiency from make model and urbanity
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the city and highway fuel efficiencies of the automobile [make model](http://data.brighterplanet.com/automobile_models) (*km / l*)
            # * Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`
            quorum 'from make model and urbanity', :needs => [:make_model, :urbanity], :complies => [:ghg_protocol, :iso] do |characteristics|
              fuel_efficiency_city = characteristics[:make_model].fuel_efficiency_city
              fuel_efficiency_highway = characteristics[:make_model].fuel_efficiency_highway
              urbanity = characteristics[:urbanity]
              if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
              end
            end
            
            #### Fuel efficiency from size class, hybridity multiplier, and urbanity
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the automobile [size class](http://data.brighterplanet.com/automobile_makes) city and highway fuel efficiency (*km / l*)
            # * Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`
            # * Multiplies the result by the `hybridity multiplie`r
            quorum 'from size class, hybridity multiplier, and urbanity', :needs => [:size_class, :hybridity_multiplier, :urbanity], :complies => [:ghg_protocol, :iso] do |characteristics|
              fuel_efficiency_city = characteristics[:size_class].fuel_efficiency_city
              fuel_efficiency_highway = characteristics[:size_class].fuel_efficiency_highway
              urbanity = characteristics[:urbanity]
              if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                (1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))) * characteristics[:hybridity_multiplier]
              end
            end
            
            #### Fuel efficiency from make year and hybridity multiplier
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the automobile [make year](http://data.brighterplanet.com/automobile_make_years) combined fuel efficiency (*km / l*)
            # * Multiplies the combined fuel efficiency by the `hybridity multiplier`
            quorum 'from make year and hybridity multiplier', :needs => [:make_year, :hybridity_multiplier], :complies => [:ghg_protocol, :iso] do |characteristics|
              characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            #### Fuel efficiency from make and hybridity multiplier
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the automobile [make](http://data.brighterplanet.com/automobile_makes) combined fuel efficiency (*km / l*)
            # * Multiplies the combined fuel efficiency by the `hybridity multiplier`
            quorum 'from make and hybridity multiplier', :needs => [:make, :hybridity_multiplier], :complies => [:ghg_protocol, :iso] do |characteristics|
              if characteristics[:make].fuel_efficiency.nil?
                nil
              else
                characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
              end
            end
            
            #### Fuel efficiency from hybridity multiplier
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Takes a default `fuel efficiency` of 8.58 *km / l*, calculated from total US automobile vehicle miles travelled and gasoline and diesel consumption.
            # * Multiplies the `fuel efficiency` by the `hybridity multiplier`
            quorum 'from hybridity multiplier', :needs => :hybridity_multiplier, :complies => [:ghg_protocol, :iso] do |characteristics|
              base.fallback.fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          ### Hybridity multiplier calculation
          # Returns the `hybridity multiplier`.
          # This value may be used to adjust the fuel efficiency based on whether the automobile is a hybrid or conventional vehicle.
          committee :hybridity_multiplier do
            #### Hybridity multiplier from size class, hybridity, and urbanity
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the appropriate city and highway hybridity multipliers for the automobile [size class](http://data.brighterplanet.com/automobile_size_classes)
            # * Calculates the harmonic mean of those multipliers, weighted by `urbanity`
            quorum 'from size class, hybridity, and urbanity', :needs => [:size_class, :hybridity, :urbanity], :complies => [:ghg_protocol, :iso] do |characteristics|
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
            
            #### Hybridity multiplier from hybridity and urbanity
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Looks up the appropriate default city and highway hybridity multipliers
            # * Calculates the harmonic mean of those multipliers, weighted by `urbanity`
            quorum 'from hybridity and urbanity', :needs => [:hybridity, :urbanity], :complies => [:ghg_protocol, :iso] do |characteristics|
              drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
              urbanity = characteristics[:urbanity]
              fuel_efficiency_multipliers = {
                :city => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                :highway => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
              }
              1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
            end
            
            #### Default hybridity multiplier
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses a default `hybridity multiplier` of 1.
            quorum 'default', :complies => [:ghg_protocol, :iso] do
              base.fallback.hybridity_multiplier
            end
          end
          
          ### Hybridity calculation
          # Returns the client-input `hybridity`. This indicates whether the automobile is a hybrid electric vehicle or a conventional vehicle.
          
          ### Size class calculation
          # Returns the client-input automobile [size class](http://data.brighterplanet.com/automobile_size_classes).
          
          ### Speed calculation
          # Returns the average `speed` at which the automobile travels (*km / hour*)
          committee :speed do
            #### Speed from urbanity
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # * Takes average city and highway driving speeds from [EPA (2006)](http://www.epa.gov/fueleconomy/420r06017.pdf) and converts from *miles / hour* to *km / hour*
            # * Calculates the harmonic mean of those speeds, weighted by `urbanity`
            quorum 'from urbanity', :needs => :urbanity, :complies => [:ghg_protocol, :iso] do |characteristics|
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
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses an `urbanity` of 0.43 after [EPA (2009) Appendix A](http://www.epa.gov/otaq/cert/mpg/fetrends/420r09014-appx-a.pdf)
            quorum 'default', :complies => [:ghg_protocol, :iso] do
              base.fallback.urbanity
            end
          end
          
          ### Fuel type calculation
          # Returns the `fuel type` used by the automobile.
          committee :fuel_type do
            #### Fuel type from client input
            # **Complies:** All
            #
            # Uses the client-input [fuel type](http://data.brighterplanet.com/fuel_types).
            
            #### Fuel type from make model year variant
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Looks up the [variant](http://data.brighterplanet.com/automobile_variants) `fuel type`.
            quorum 'from make model year variant', :needs => :make_model_year_variant, :complies => [:ghg_protocol, :iso] do |characteristics|
              characteristics[:make_model_year_variant].fuel_type
            end
          end
          
          ### Active subtimeframe calculation
          # Returns the portion of the `timeframe` that falls between the `acquisition` and `retirement`.
          committee :active_subtimeframe do
            #### Active subtimeframe from timeframe, acquisition, and retirement
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses the portion of the `timeframe` that falls between `acquisition` and `retirement`.
            quorum 'from acquisition and retirement', :needs => [:acquisition, :retirement], :complies => [:ghg_protocol, :iso] do |characteristics, timeframe|
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
            
            #### Acquisition from make model year variant
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses the first day of the client-input automobile [make model year variant](http://data.brighterplanet.com/automobile_variants) year.
            quorum 'from make model year variant', :needs => [:make_model_year_variant], :complies => [:ghg_protocol, :iso] do |characteristics|
              Date.new characteristics[:make_model_year_variant].year, 1, 1
            end
            
            #### Acquisition from make model year
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses the first day of the client-input automobile [make model year](http://data.brighterplanet.com/automobile_model_years) year.
            quorum 'from make model year', :needs => [:make_model_year], :complies => [:ghg_protocol, :iso] do |characteristics|
              Date.new characteristics[:make_model_year].year, 1, 1
            end
            
            #### Acquisition from make year
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses the first day of the client-input automobile [make year](http://data.brighterplanet.com/automobile_make_years) year.
            quorum 'from make year', :needs => [:make_year], :complies => [:ghg_protocol, :iso] do |characteristics|
              Date.new characteristics[:make_year].year, 1, 1
            end
            
            #### Acquisition from timeframe or retirement
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses the first day of the `timeframe`, or the `retirement`, whichever is earlier.
            quorum 'from retirement', :appreciates => :retirement, :complies => [:ghg_protocol, :iso] do |characteristics, timeframe|
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
            # **Complies:** GHG Protocol, ISO 14064-1
            #
            # Uses the last day of the `timeframe`, or the `acquisition`, whichever is later.
            quorum 'from acquisition', :appreciates => :acquisition, :complies => [:ghg_protocol, :iso] do |characteristics, timeframe|
              [ timeframe.to, characteristics[:acquisition] ].compact.max
            end
          end
          
          ### Make model year variant calculation
          # Returns the client-input automobile [make model year variant](http://data.brighterplanet.com/automobile_variants).
          
          ### Make model year calculation
          # Returns the client-input automobile [make model year](http://data.brighterplanet.com/automobile_model_years).
          
          ### Make model calculation
          # Returns the client-input automobile [make model](http://data.brighterplanet.com/automobile_models).
          
          ### Make year calculation
          # Returns the client-input automobile [make year](http://data.brighterplanet.com/automobile_make_years).
          
          ### Make calculation
          # Returns the client-input automobile [make](http://data.brighterplanet.com/automobile_makes).
          
          ### Timeframe calculation
          # Returns the `timeframe`.
          # This is the period during which to calculate emissions.
            
            #### Timeframe from client input
            # **Complies:** All
            #
            # Uses the client-input `timeframe`.
            
            #### Default timeframe
            # **Complies:** All
            #
            # Uses the current calendar year.
        end
      end
    end
  end
end
