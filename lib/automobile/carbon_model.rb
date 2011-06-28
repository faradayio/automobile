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
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module Automobile
    module CarbonModel
      def self.included(base)
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*).
          committee :emission do
            #### Emission from CO<sub>2</sub> emission, CH<sub>4</sub> emission, N<sub>2</sub>O emission, and HFC emission
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission',
              :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Sums the non-biogenic emissions to give *kg CO<sub>2</sub>e*.
                characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
            
            #### Emission from default
            quorum 'default' do
              # Displays an error message if the previous method fails.
              raise "The emission committee's default quorum should never be called"
            end
          end
          
          ### CO<sub>2</sub> emission calculation
          # Returns the `co2 emission` (*kg CO<sub>2</sub>*).
          committee :co2_emission do
            #### CO<sub>2</sub> emission from fuel use and CO<sub>2</sub> emission factor
            quorum 'from fuel use and co2 emission factor',
              :needs => [:fuel_use, :co2_emission_factor],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Multiplies `fuel use` (*l*) by the `co2 emission factor` (*kg CO<sub>2</sub> / l*) to give *kg CO<sub>2</sub>*.
                characteristics[:fuel_use] * characteristics[:co2_emission_factor]
            end
          end
          
          ### CO<sub>2</sub> biogenic emission calculation
          # Returns the `co2 biogenic emission` (*kg CO<sub>2</sub>*).
          committee :co2_biogenic_emission do
            #### CO<sub>2</sub> biogenic emission from fuel use and CO<sub>2</sub> biogenic emission factor
            quorum 'from fuel use and co2 biogenic emission factor',
              :needs => [:fuel_use, :co2_biogenic_emission_factor],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Multiplies `fuel use` (*l*) by the `co2 biogenic emission factor` (*kg CO<sub>2</sub> / l*) to give *kg CO<sub>2</sub>*.
                characteristics[:fuel_use] * characteristics[:co2_biogenic_emission_factor]
            end
          end
          
          ### CH<sub>4</sub> emission calculation
          # Returns the `ch4 emission` (*kg CO<sub>2</sub>e*).
          committee :ch4_emission do
            #### CH<sub>4</sub> emission from fuel use and CH<sub>4</sub> emission factor
            quorum 'from fuel use and ch4 emission factor',
              :needs => [:fuel_use, :ch4_emission_factor],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Multiplies `fuel use` (*l*) by the `ch4 emission factor` (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
                characteristics[:fuel_use] * characteristics[:ch4_emission_factor]
            end
          end
          
          ### N<sub>2</sub>O emission calculation
          # Returns the `n2o emission` (*kg CO<sub>2</sub>e*).
          committee :n2o_emission do
            #### N<sub>2</sub>O emission from fuel use and N<sub>2</sub>O emission factor
            quorum 'from fuel use and n2o emission factor',
              :needs => [:fuel_use, :n2o_emission_factor],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Multiplies `fuel use` (*l*) by the `n2o emission factor` (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
                characteristics[:fuel_use] * characteristics[:n2o_emission_factor]
            end
          end
          
          ### HFC emission calculation
          # Returns the `hfc emission` (*kg CO<sub>2</sub>e*).
          committee :hfc_emission do
            #### HFC emission from fuel use and HFC emission factor
            quorum 'from fuel use and hfc emission factor',
              :needs => [:fuel_use, :hfc_emission_factor],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Multiplies `fuel use` (*l*) by the `hfc emission factor` (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
                characteristics[:fuel_use] * characteristics[:hfc_emission_factor]
            end
          end
          
          ### CO<sub>2</sub> emission factor calculation
          # Returns the `co2 emission factor` (*kg / l*).
          committee :co2_emission_factor do
            #### CO<sub>2</sub> emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `co2 emission factor` (*kg / l*).
                characteristics[:automobile_fuel].co2_emission_factor
            end
          end
          
          ### CO<sub>2</sub> biogenic emission factor calculation
          # Returns the `co2 biogenic emission factor` (*kg / l*).
          committee :co2_biogenic_emission_factor do
            #### CO<sub>2</sub> biogenic emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `co2 biogenic emission factor` (*kg / l*).
                characteristics[:automobile_fuel].co2_biogenic_emission_factor
            end
          end
          
          ### CH<sub>4</sub> emission factor calculation
          # Returns the `ch4 emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :ch4_emission_factor do
            #### CH<sub>4</sub> emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `ch4 emission factor` (*kg CO</sub>2</sub>e / l*).
                characteristics[:automobile_fuel].ch4_emission_factor
            end
          end
          
          ### N<sub>2</sub>O emission factor calculation
          # Returns the `n2o emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :n2o_emission_factor do
            #### N<sub>2</sub>O emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `n2o emission factor` (*kg CO</sub>2</sub>e / l*).
                characteristics[:automobile_fuel].n2o_emission_factor
            end
          end
          
          ### HFC emission factor calculation
          # Returns the `hfc emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :hfc_emission_factor do
            #### HFC emission factor from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [fuel](http://data.brighterplanet.com/fuels) `hfc emission factor` (*kg CO</sub>2</sub>e / l*).
                characteristics[:automobile_fuel].hfc_emission_factor
            end
          end
          
          ### Fuel use calculation
          # Returns the trip `fuel use` (*l*).
          committee :fuel_use do
            #### Fuel use from fuel efficiency and distance
            quorum 'from fuel efficiency and distance',
              :needs => [:fuel_efficiency, :distance],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Divides the `distance` (*km*) by the `fuel efficiency` (*km / l*) to give *l*.
                characteristics[:distance] / characteristics[:fuel_efficiency]
            end
          end
          
          ### Distance calculation
          # Returns the `distance` (*km*). This is the distance the automobile travelled during the `active subtimeframe`.
          committee :distance do
            #### Distance from annual distance
            quorum 'from annual distance',
              :needs => [:annual_distance, :active_subtimeframe],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Multiplies the `annual distance` (*km*) by the fraction of the calendar year in which the `timeframe` falls that overlaps with the `active subtimeframe`.
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
            quorum 'from weekly distance and timeframe',
              :needs => :weekly_distance,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Divides the `weekly distance` (*km*) by 7 and multiplies by the number of days in the calendar year in which the `timeframe` falls.
                (characteristics[:weekly_distance] / 7 ) * timeframe.year.days
            end
            
            #### Annual distance from daily distance and timeframe
            quorum 'from daily distance and timeframe',
              :needs => :daily_distance,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Multiplies the `daily distance` (*km*) by the number of days in the calendar year in which the `timeframe` falls.
                characteristics[:daily_distance] * timeframe.year.days
            end
            
            #### Annual distance from daily duration, speed, and timeframe
            quorum 'from daily duration, speed, and timeframe',
              :needs => [:daily_duration, :speed],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Multiplies the `daily duration` (*hours*) by the `speed` (*km / hour*) to give *km*. Multiplies the result by the number of days in the calendar year in which the `timeframe` falls.
                characteristics[:daily_duration] * characteristics[:speed] * timeframe.year.days
            end
            
            #### Annual distance from size class
            quorum 'from size class',
              :needs => :size_class,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the automobile [size class](http://data.brighterplanet.com/automobile_size_classes) `annual distance` (*km*).
                characteristics[:size_class].annual_distance
            end
            
            #### Annual distance from automobile fuel
            quorum 'from automobile fuel',
              :needs => :automobile_fuel,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [automobile fuel](http://data.brighterplanet.com/automobile_fuels) `annual distance` (*km*).
                characteristics[:automobile_fuel].annual_distance
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
          
          ### Automobile fuel calculation
          # Returns the type of `automobile fuel` used.
          committee :automobile_fuel do
            #### Automobile fuel from client input
            # **Complies:** All
            #
            # Uses the client-input [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            
            #### Automobile fuel from make model year variant
            quorum 'from make model year variant',
              :needs => :make_model_year_variant,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the [variant](http://data.brighterplanet.com/automobile_make_model_year_variants) `automobile fuel`.
                characteristics[:make_model_year_variant].fuel
            end
            
            #### Default automobile fuel
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the default [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
                AutomobileFuel.fallback
            end
          end
          
          ### Speed calculation
          # Returns the average `speed` at which the automobile travels (*km / hour*).
          committee :speed do
            #### Speed from client input
            # **Complies:** All
            #
            # Uses the client-input `speed` (*km / hour*).
            
            #### Speed from urbanity
            quorum 'from urbanity',
              :needs => :urbanity,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Takes average city and highway driving speeds from [EPA (2006)](http://www.epa.gov/fueleconomy/420r06017.pdf) and converts from *miles / hour* to *km / hour*, then calculates the harmonic mean of those speeds weighted by `urbanity`.
                1 / (characteristics[:urbanity] / base.fallback.city_speed + (1 - characteristics[:urbanity]) / base.fallback.highway_speed)
            end
          end
          
          ### Fuel efficiency calculation
          # Returns the `fuel efficiency` (*km / l*)
          committee :fuel_efficiency do
            #### Fuel efficiency from client input
            # **Complies:** All
            #
            # Uses the client-input `fuel efficiency` (*km / l*).
            
            #### Fuel efficiency from make model year variant and urbanity
            quorum 'from make model year variant and urbanity',
              :needs => [:make_model_year_variant, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the city and highway fuel efficiencies of the automobile [make model year variant](http://data.brighterplanet.com/automobile_make_model_year_variants) (*km / l*).
                fuel_efficiency_city = characteristics[:make_model_year_variant].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model_year_variant].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            #### Fuel efficiency from make model year and urbanity
            quorum 'from make model year and urbanity',
              :needs => [:make_model_year, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the city and highway fuel efficiencies of the automobile [make model year](http://data.brighterplanet.com/automobile_make_model_years) (*km / l*).
                fuel_efficiency_city = characteristics[:make_model_year].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model_year].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            #### Fuel efficiency from make model and urbanity
            quorum 'from make model and urbanity',
              :needs => [:make_model, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the city and highway fuel efficiencies of the automobile [make model](http://data.brighterplanet.com/automobile_make_models) (*km / l*).
                fuel_efficiency_city = characteristics[:make_model].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            #### Fuel efficiency from size class, hybridity multiplier, and urbanity
            quorum 'from size class, hybridity multiplier, and urbanity',
              :needs => [:size_class, :hybridity_multiplier, :urbanity],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the automobile [size class](http://data.brighterplanet.com/automobile_makes) city and highway fuel efficiency (*km / l*).
                fuel_efficiency_city = characteristics[:size_class].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:size_class].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  # Calculates the harmonic mean of those fuel efficiencies, weighted by `urbanity`, and multiplies the result by the `hybridity multiplier`.
                  (1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))) * characteristics[:hybridity_multiplier]
                end
            end
            
            #### Fuel efficiency from make year and hybridity multiplier
            quorum 'from make year and hybridity multiplier',
              :needs => [:make_year, :hybridity_multiplier],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the automobile [make year](http://data.brighterplanet.com/automobile_make_years) combined fuel efficiency (*km / l*) and multiplies it by the `hybridity multiplier`.
                characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            #### Fuel efficiency from make and hybridity multiplier
            quorum 'from make and hybridity multiplier',
              :needs => [:make, :hybridity_multiplier],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the automobile [make](http://data.brighterplanet.com/automobile_makes) combined fuel efficiency (*km / l*) and multiplies it by the `hybridity multiplier`.
                if characteristics[:make].fuel_efficiency.present?
                  characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
                end
            end
            
            #### Fuel efficiency from hybridity multiplier
            quorum 'from hybridity multiplier',
              :needs => :hybridity_multiplier,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Takes a default `fuel efficiency` of 8.58 *km / l*, calculated from total US automobile vehicle miles travelled and gasoline and diesel use, and multiplies it by the `hybridity multiplier`.
                base.fallback.fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          ### Size class calculation
          # Returns the client-input automobile [size class](http://data.brighterplanet.com/automobile_size_classes).
          
          ### Hybridity multiplier calculation
          # Returns the `hybridity multiplier`.
          # This value may be used to adjust the fuel efficiency based on whether the automobile is a hybrid or conventional vehicle.
          committee :hybridity_multiplier do
            #### Hybridity multiplier from size class, hybridity, and urbanity
            quorum 'from size class, hybridity, and urbanity', 
              :needs => [:size_class, :hybridity, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the appropriate city and highway hybridity multipliers for the automobile [size class](http://data.brighterplanet.com/automobile_size_classes).
                drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
                urbanity = characteristics[:urbanity]
                size_class = characteristics[:size_class]
                fuel_efficiency_multipliers = {
                  :city => size_class.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                  :highway => size_class.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                }
                if fuel_efficiency_multipliers.values.any?(&:present?)
                  # Calculates the harmonic mean of those multipliers, weighted by `urbanity`.
                  1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
                else
                  nil
                end
            end
            
            #### Hybridity multiplier from hybridity and urbanity
            quorum 'from hybridity and urbanity',
              :needs => [:hybridity, :urbanity],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Looks up the appropriate default city and highway hybridity multipliers.
                drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
                urbanity = characteristics[:urbanity]
                fuel_efficiency_multipliers = {
                  :city => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                  :highway => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                }
                # Calculates the harmonic mean of those multipliers, weighted by `urbanity`.
                1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
            end
            
            #### Default hybridity multiplier
            quorum 'default',
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                # Uses a default `hybridity multiplier` of 1.
                base.fallback.hybridity_multiplier
            end
          end
          
          ### Hybridity calculation
          # Returns the client-input `hybridity`. This indicates whether the automobile is a hybrid electric vehicle or a conventional vehicle.
          
          ### Urbanity calculation
          # Returns the `urbanity`.
          # This is the fraction of the total distance driven that occurs on towns and city streets as opposed to highways (defined using a 45 miles per hour "speed cutpoint").
          committee :urbanity do
            #### Urbanity from urbanity estimate
            quorum 'from urbanity estimate',
              :needs => :urbanity_estimate,
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the `urbanity estimate` if it is from zero to one.
                if characteristics[:urbanity_estimate] >= 0 and characteristics[:urbanity_estimate] <= 1
                  characteristics[:urbanity_estimate]
                end
            end
            
            #### Default urbanity
            quorum 'default',
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                # Uses an `urbanity` of 0.43 after [EPA (2009) Appendix A](http://www.epa.gov/otaq/cert/mpg/fetrends/420r09014-appx-a.pdf).
                base.fallback.urbanity_estimate
            end
          end
          
          ### Urbanity estimate calculation
          # Returns the client-input `urbanity estimate`. This is the fraction of the total distance driven that occurs on towns and city streets as opposed to highways (defined using a 45 miles per hour "speed cutpoint").
          
          ### Active subtimeframe calculation
          # Returns the portion of the `timeframe` that falls between the `acquisition` and `retirement`.
          committee :active_subtimeframe do
            #### Active subtimeframe from timeframe, acquisition, and retirement
            quorum 'from acquisition and retirement',
              :needs => [:acquisition, :retirement],
              # **Complies:** GHG Protocol Scope 1, GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Uses the portion of the `timeframe` that falls between `acquisition` and `retirement`.
                Timeframe.constrained_new characteristics[:acquisition].to_date, characteristics[:retirement].to_date, timeframe
            end
          end
          
          ### Acquisition calculation
          # Returns the date of the automobile's `acquisition`. This is the date the automobile was put into use.
          committee :acquisition do
            #### Acquisition from client input
            # **Complies:** All
            #
            # Uses the client-input `acquisition`.
            
            #### Acquisition from make model year variant
            quorum 'from make model year variant',
              :needs => [:make_model_year_variant],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the first day of the client-input automobile [make model year variant](http://data.brighterplanet.com/automobile_variants) year.
                Date.new characteristics[:make_model_year_variant].year, 1, 1
            end
            
            #### Acquisition from make model year
            quorum 'from make model year',
              :needs => [:make_model_year],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the first day of the client-input automobile [make model year](http://data.brighterplanet.com/automobile_model_years) year.
                Date.new characteristics[:make_model_year].year, 1, 1
            end
            
            #### Acquisition from make year
            quorum 'from make year',
              :needs => [:make_year],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                # Uses the first day of the client-input automobile [make year](http://data.brighterplanet.com/automobile_make_years) year.
                Date.new characteristics[:make_year].year, 1, 1
            end
            
            #### Acquisition from timeframe or retirement
            quorum 'from retirement',
              :appreciates => :retirement,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Uses the first day of the `timeframe`, or the `retirement`, whichever is earlier.
                [ timeframe.from, characteristics[:retirement] ].compact.min
            end
          end
          
          ### Retirement calculation
          # Returns the date of the automobile's `retirement`. This is the date the automobile was taken out of use.
          committee :retirement do
            #### Retirement from client input
            # **Complies:** All
            #
            # Uses the client-input `retirement`.
            
            #### Retirement from timeframe or acquisition
            quorum 'from acquisition',
              :appreciates => :acquisition,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                # Uses the last day of the `timeframe`, or the `acquisition`, whichever is later.
                [ timeframe.to, characteristics[:acquisition] ].compact.max
            end
          end
          
          ### Make model year variant calculation
          # Returns the client-input automobile [make model year variant](http://data.brighterplanet.com/automobile_make_model_year_variants).
          
          ### Make model year calculation
          # Returns the client-input automobile [make model year](http://data.brighterplanet.com/automobile_make_model_years).
          
          ### Make model calculation
          # Returns the client-input automobile [make model](http://data.brighterplanet.com/automobile_make_models).
          
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
