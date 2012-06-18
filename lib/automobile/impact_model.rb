# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

### Automobile impact model
# This model is used by the [Brighter Planet](http://brighterplanet.com) [CM1 web service](http://impact.brighterplanet.com) to calculate the impacts of an automobile, such as energy use and greenhouse gas emissions.

##### Timeframe
# The model calculates impacts that occured during a particular time period (`timeframe`).
# For example if the `timeframe` is February 2010, an automobile put into use (`acquisition`) in December 2009 and taken out of use (`retirement`) in March 2010 will have impacts because it was in use during January 2010.
# An automobile put into use in March 2010 or taken out of use in January 2010 will have zero impacts, because it was not in use during February 2010.
#
# The default `timeframe` is the current calendar year.

##### Calculations
# The final impacts are the result of the calculations below. These are performed in reverse order, starting with the last calculation listed and finishing with the greenhouse gas emissions calculation.
#
# Each calculation listing shows:
#
# * value returned (*units of measurement*)
# * description of the value
# * calculation methods, listed from most to least preferred
#
# Some methods use `values` returned by prior calculations. If any of these `values` are unknown the method is skipped.
# If all the methods for a calculation are skipped, the value the calculation would return is unknown.

##### Standard compliance
# When compliance with a particular standard is requested, all methods that do not comply with that standard are ignored.
# Thus any `values` a method needs will have been calculated using a compliant method or will be unknown.
# To see which standards a method complies with, look at the `:complies =>` section of the code in the right column.
#
# Client input complies with all standards.

##### Collaboration
# Contributions to this impact model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module Automobile
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          # * * *
          
          #### Carbon (*kg CO<sub>2</sub>e*)
          # *The automobile's total anthropogenic greenhouse gas emissions during `active subtimeframe`.*
          committee :carbon do
            # Sum `co2 emission` (*kg*), `ch4 emission` (*kg CO<sub>2</sub>e*), `n2o emission` (*kg CO<sub>2</sub>e*), and `hfc emission` (*kg CO<sub>2</sub>e*) to give *kg CO<sub>2</sub>e*.
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission', :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
          end
          
          #### CO<sub>2</sub> emission (*kg*)
          # *The automobile's CO<sub>2</sub> emissions from anthropogenic sources during `active subtimeframe`.*
          committee :co2_emission do
            # Multiply `fuel use` (*various*) by `co2 emission factor` (*kg / various*) to give *kg*.
            quorum 'from fuel use and co2 emission factor', :needs => [:fuel_use, :co2_emission_factor],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:co2_emission_factor]
            end
          end
          
          #### CO<sub>2</sub> biogenic emission (*kg*)
          # *The automobile's CO<sub>2</sub> emissions from biogenic sources during `active subtimeframe`.*
          committee :co2_biogenic_emission do
            # Multiply `fuel use` (*various*) by `co2 biogenic emission factor` (*kg / various*) to give *kg*.
            quorum 'from fuel use and co2 biogenic emission factor', :needs => [:fuel_use, :co2_biogenic_emission_factor],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:co2_biogenic_emission_factor]
            end
          end
          
          #### CH<sub>4</sub> emission (*kg CO<sub>2</sub>e*)
          # *The automobile's CH<sub>4</sub> emissions during `active subtimeframe`.*
          committee :ch4_emission do
            # Multiply `distance` (*km*) by `ch4 emission factor` (*kg CO<sub>2</sub>e / km*) to give *kg CO<sub>2</sub>e*.
            quorum 'from distance and ch4 emission factor', :needs => [:distance, :ch4_emission_factor],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:distance] * characteristics[:ch4_emission_factor]
            end
          end
          
          #### N<sub>2</sub>O emission (*kg CO<sub>2</sub>e*)
          # *The automobile's N<sub>2</sub>O emissions during `active subtimeframe`.*
          committee :n2o_emission do
            # Multiply `distance` (*km*) by `n2o emission factor` (*kg CO<sub>2</sub>e / km*) to give *kg CO<sub>2</sub>e*.
            quorum 'from distance and n2o emission factor', :needs => [:distance, :n2o_emission_factor],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:distance] * characteristics[:n2o_emission_factor]
            end
          end
          
          #### HFC emission (*kg CO<sub>2</sub>e*)
          # *The automobile's HFC emissions during `active subtimeframe`.*
          committee :hfc_emission do
            # Multiply `distance` (*km*) by `hfc emission factor` (*kg CO<sub>2</sub>e / km*) to give *kg CO<sub>2</sub>e*.
            quorum 'from distance and hfc emission factor', :needs => [:distance, :hfc_emission_factor],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:distance] * characteristics[:hfc_emission_factor]
            end
          end
          
          #### CO<sub>2</sub> emission factor (*kg / various*)
          # *The CO<sub>2</sub> emission factor.*
          committee :co2_emission_factor do
            # Use the `automobile fuel` co2 emission factor (*kg / various*).
            quorum 'from automobile fuel', :needs => :automobile_fuel,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:automobile_fuel].co2_emission_factor
            end
            
            # Otherwise use the `country` electricity emission factor (*kg CO<sub>2</sub>e / kWh*) (electricity is the only automobile fuel without a co2 biogenic emission factor).
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:country].electricity_emission_factor
            end
            
            # Otherwise use the global average electricity emission factor (*kg CO<sub>2</sub>e / kWh*) (electricity is the only automobile fuel without a co2 biogenic emission factor).
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso] do
                Country.fallback.electricity_emission_factor
            end
          end
          
          #### CO<sub>2</sub> biogenic emission factor (*kg / various*)
          # *The CO<sub>2</sub> emission factor.*
          committee :co2_biogenic_emission_factor do
            # Use the `automobile fuel` co2 biogenic emission factor (*kg / various*).
            quorum 'from automobile fuel', :needs => :automobile_fuel,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:automobile_fuel].co2_biogenic_emission_factor
            end
            
            # Otherwise use a default of 0 *kg / kWh* (electricity is the only automobile fuel without a co2 biogenic emission factor).
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso] do
                0.0
            end
          end
          
          #### CH<sub>4</sub> emission factor (*kg CO<sub>2</sub>e / km*)
          # *The CH<sub>4</sub> emission factor.*
          committee :ch4_emission_factor do
            # Use the `type fuel year` ch4 emission factor (*kg CO<sub>2</sub>e / km*).
            quorum 'from type fuel year', :needs => :type_fuel_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:type_fuel_year].ch4_emission_factor
            end
            
            # Otherwise use the `type fuel` ch4 emission factor (*kg CO<sub>2</sub>e / km*).
            quorum 'from type fuel', :needs => :type_fuel,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:type_fuel].ch4_emission_factor
            end
            
            # Otherwise use the `automobile fuel` ch4 emission factor (*kg CO<sub>2</sub>e / km*).
            quorum 'from automobile fuel', :needs => :automobile_fuel,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:automobile_fuel].ch4_emission_factor
            end
          end
          
          #### N<sub>2</sub>O emission factor (*kg CO<sub>2</sub>e / km*)
          # *The N<sub>2</sub>O emission factor.*
          committee :n2o_emission_factor do
            # Use the `type fuel year` n2o emission factor (*kg CO<sub>2</sub>e / km*).
            quorum 'from type fuel year', :needs => :type_fuel_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:type_fuel_year].n2o_emission_factor
            end
            
            # Otherwise use the `type fuel` n2o emission factor (*kg CO<sub>2</sub>e / km*).
            quorum 'from type fuel', :needs => :type_fuel,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:type_fuel].n2o_emission_factor
            end
            
            # Otherwise use the `automobile fuel` n2o emission factor (*kg CO<sub>2</sub>e / km*).
            quorum 'from automobile fuel', :needs => :automobile_fuel,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:automobile_fuel].n2o_emission_factor
            end
          end
          
          #### HFC emission (*kg CO<sub>2</sub>e / km*)
          # *The automobile's HFC emission factor.*
          committee :hfc_emission_factor do
            # Use the `activity year type` hfc emission factor *kg CO<sub>2</sub>e / km*.
            quorum 'from activity year type', :needs => :activity_year_type,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:activity_year_type].hfc_emission_factor
            end
            
            # Otherwise use the `activity year` hfc emission factor *kg CO<sub>2</sub>e / km*.
            quorum 'from activity year', :needs => :activity_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:activity_year].hfc_emission_factor
            end
          end
          
          #### Activity year type
          # *The automobile's [activity year and type](http://data.brighterplanet.com/automobile_activity_year_types).*
          committee :activity_year_type do
            # Find the best match for `active subtimeframe` and `automobile_type`.
            quorum 'from active subtimeframe and automobile type', :needs => [:active_subtimeframe, :automobile_type],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileActivityYearType.find_by_type_name_and_closest_year(characteristics[:automobile_type].value, characteristics[:active_subtimeframe].start_date.year)
            end
          end
          
          #### Activity year
          # *The [year](http://data.brighterplanet.com/automobile_activity_years) in which the trip occurred.*
          committee :activity_year do
            # Find the best match for `active subtimeframe`.
            quorum 'from active subtimeframe', :needs => :active_subtimeframe,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileActivityYear.find_by_closest_year(characteristics[:active_subtimeframe].start_date.year)
            end
          end
          
          #### Energy (*MJ*)
          # *The automobile's energy use during `active subtimeframe`.*
          committee :energy do
            # Multiply `fuel use` (*various*) by the `automobile fuel` energy content (*MJ / various*) to give *MJ*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel] do |characteristics|
              characteristics[:fuel_use] * characteristics[:automobile_fuel].energy_content
            end
          end
          
          #### Fuel use (*various*)
          # *The automobile's fuel use during `active subtimeframe`.*
          committee :fuel_use do
            # Multiply `annual fuel use` (*various*) by the fraction of the calendar year in which `timeframe` falls that overlaps with `active subtimeframe` to give *various*.
            quorum 'from annual fuel use, active subtimeframe, and timeframe', :needs => [:annual_fuel_use, :active_subtimeframe],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:annual_fuel_use] * (characteristics[:active_subtimeframe] / timeframe.year)
            end
          end
          
          #### Annual fuel use (*various*)
          # *The fuel the automobile would use if it were used for the entire calendar year in which `timeframe` falls.*
          # Note that this will be **more** than the actual fuel used if the automobile was not in use for the entire calendar year (if either `acquisition` or `retirement` occurs during the calendar year in which `timeframe` falls).
          committee :annual_fuel_use do
            # Use client input, if available.
            
            # Otherwise divide `annual distance` (*km*) by `fuel efficiency` (*km / various*) to give *various*.
            quorum 'from fuel efficiency, annual distance, and automobile fuel', :needs => [:fuel_efficiency, :annual_distance, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:automobile_fuel].non_liquid?
                  characteristics[:annual_distance] / characteristics[:fuel_efficiency] * AutomobileFuel.find('gasoline').energy_content / characteristics[:automobile_fuel].energy_content
                else
                  characteristics[:annual_distance] / characteristics[:fuel_efficiency]
                end
            end
          end
          
          #### Distance (*km*)
          # *The distance the automobile travelled during `active subtimeframe`.*
          committee :distance do
            # Multiply `annual distance` (*km*) by the fraction of the calendar year in which `timeframe` falls that overlaps with `active subtimeframe` to give *km*.
            quorum 'from annual distance, active subtimeframe, and timeframe', :needs => [:annual_distance, :active_subtimeframe],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:annual_distance] * (characteristics[:active_subtimeframe] / timeframe.year)
            end
          end
          
          #### Annual distance (*km*)
          # *The distance the automobile would travel if it were used for the entire calendar year in which `timeframe` falls.*
          # Note that this will be **more** than the actual distance traveled if the automobile was not in use for the entire calendar year (if either `acquisition` or `retirement` occurs during the calendar year in which `timeframe` falls).
          committee :annual_distance do
            # Use client input, if available.
            
            # Otherwise multiply client-input `fuel use` (*various*) by `fuel efficiency` (*km / l*) to give *km*.
            # This is necessary to make sure `distance` is reasonable given `fuel use` - otherwise ch4 and n2o emissions may be absurdly large.
            quorum 'from annual fuel use and fuel efficiency', :needs => [:annual_fuel_use, :fuel_efficiency],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:annual_fuel_use] * characteristics[:fuel_efficiency]
            end
            
            # Otherwise divide `weekly distance` (*km*) by 7 and multiply by the number of days in the calendar year in which `timeframe` falls to give *km*.
            quorum 'from weekly distance and timeframe', :needs => :weekly_distance,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                (characteristics[:weekly_distance] / 7 ) * timeframe.year.days
            end
            
            # Otherwise multiply `daily distance` (*km*) by the number of days in the calendar year in which `timeframe` falls to give *km*.
            quorum 'from daily distance and timeframe', :needs => :daily_distance,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:daily_distance] * timeframe.year.days
            end
            
            # Otherwise divide `daily duration` (*seconds*) by 3600 (*seconds / hour*) and multiply by `speed` (*km / hour*) to give *km*.
            # Multiply by the number of days in the calendar year in which `timeframe` falls to give *km*.
            quorum 'from daily duration, speed, and timeframe', :needs => [:daily_duration, :speed],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:daily_duration] / 3600.0 * characteristics[:speed] * timeframe.year.days
            end
            
            # Otherwise use the `type fuel year` annual distance (*km*).
            quorum 'from type fuel year', :needs => :type_fuel_year,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:type_fuel_year].annual_distance
            end
            
            # Otherwise use the `type fuel` annual distance (*km*).
            quorum 'from type fuel', :needs => :type_fuel,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:type_fuel].annual_distance
            end
            
            # Otherwise use the `automobile fuel` annual distance (*km*).
            quorum 'from automobile fuel', :needs => :automobile_fuel,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:automobile_fuel].annual_distance
            end
          end
          
          #### Weekly distance (*km*)
          # *The average distance the automobile is driven each week.*
          #
          # Use client input if available.
          
          #### Daily distance (*km*)
          # *The average distance the automobile is driven each day.*
          #
          # Use client input if available.
          
          #### Type fuel year
          # *The [automobile type, automobile fuel, and year](http://data.brighterplanet.com/automobile_type_fuel_years).*
          committee :type_fuel_year do
            # Match `automobile type`, `automobile fuel`, and `year` to a record in our database.
            quorum 'from automobile type, automobile fuel, and year', :needs => [:automobile_type, :automobile_fuel, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileTypeFuelYear.find_by_type_name_and_fuel_family_and_closest_year(characteristics[:automobile_type].value, characteristics[:automobile_fuel].family, characteristics[:year].year)
            end
          end
          
          #### Type fuel
          # *The [automobile type and automobile fuel](http://data.brighterplanet.com/automobile_type_fuels).*
          committee :type_fuel do
            # Match `automobile type` and `automobile fuel` to a record in our database.
            quorum 'from automobile type and automobile fuel', :needs => [:automobile_type, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileTypeFuel.find_by_type_name_and_fuel_family(characteristics[:automobile_type].value, characteristics[:automobile_fuel].family)
            end
          end
          
          #### Automobile type
          # *The automobile's [type](http://data.brighterplanet.com/automobile_types).*
          committee :automobile_type do
            # Use the `make model year` automobile type.
            quorum 'from make model year', :needs => :make_model_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_model_year].type_name
            end
            
            # Otherwise use the `make model` automobile type.
            quorum 'from make model', :needs => :make_model,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_model].type_name
            end
            
            # Otherwise use the `size class` automobile type.
            quorum 'from size class', :needs => :size_class,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:size_class].type_name
            end
          end
          
          #### Daily duration (*seconds*)
          # *The average time the automobile is driven each day.*
          #
          # Use client input, if available.
          
          #### Speed (*km / hour*)
          # *The automobile's average speed.*
          committee :speed do
            # Use client input, if available.
            
            # Otherwise calculate the harmonic mean of the `country` average automobile city and highway speeds (*km / hour*), weighted by `urbanity`, to give *km / hour*.
            quorum 'from urbanity and country', :needs => [:urbanity, :country],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:country].automobile_city_speed and characteristics[:country].automobile_highway_speed
                  1 / (characteristics[:urbanity] / characteristics[:country].automobile_city_speed + (1 - characteristics[:urbanity]) / characteristics[:country].automobile_highway_speed)
                end
            end
            
            # Otherwise calculate the harmonic mean of the global average automobile city and highway speeds (*km / hour*), weighted by `urbanity`, to give *km / hour*.
            quorum 'from urbanity', :needs => :urbanity,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1 / (characteristics[:urbanity] / Country.fallback.automobile_city_speed + (1 - characteristics[:urbanity]) / Country.fallback.automobile_highway_speed)
            end
          end
          
          #### Fuel efficiency (*km / l*)
          # *The automobile's fuel efficiency.*
          committee :fuel_efficiency do
            # Use client input, if available.
            
            # Otherwise calculate the harmonic mean of `fuel efficiency city` (*km / l*) and `fuel efficiency highway` (*km / l*), weighted by `urbanity`, to give *km / l*.
            quorum 'from fuel efficiency city, fuel efficiency highway, and urbanity', :needs => [:fuel_efficiency_city, :fuel_efficiency_highway, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1.0 / (
                  (characteristics[:urbanity]         / characteristics[:fuel_efficiency_city]) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:fuel_efficiency_highway])
                )
            end
            
            # Otherwise look up the `size class` fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from size class, hybridity multiplier, and urbanity', :needs => [:size_class, :hybridity_multiplier, :urbanity],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                (1.0 / (
                  (characteristics[:urbanity]         / characteristics[:size_class].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:size_class].fuel_efficiency_highway)
                )) * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise multiply the `make year` fuel efficiency (*km / l*) by `hybridity multiplier` to give *km / l*.
            quorum 'from make year and hybridity multiplier', :needs => [:make_year, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise multiply the `make` fuel efficiency (*km / l*) by `hybridity multiplier` to give *km / l*.
            quorum 'from make and hybridity multiplier', :needs => [:make, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise multiply the `country` average automobile fuel efficiency (*km / l*) by `hybridity multiplier` to give *km / l*.
            quorum 'from country and hybridity multiplier', :needs => [:country, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:country].automobile_fuel_efficiency
                  characteristics[:country].automobile_fuel_efficiency * characteristics[:hybridity_multiplier]
                end
            end
            
            # Otherwise multiply the global average automobile fuel efficiency (*km / l*) by `hybridity multiplier` to give *km / l*.
            quorum 'from hybridity multiplier', :needs => :hybridity_multiplier,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                Country.fallback.automobile_fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          #### Fuel efficiency city (*km / l*)
          # *The automobile's city fuel efficiency.*
          committee :fuel_efficiency_city do
            # Use client input, if available.
            
            # Otherwise check whether `automobile fuel` is the `make model year` primary or secondary fuel and use the appropriate city fuel efficiency (*km / l*).
            quorum 'from make model year and automobile fuel', :needs => [:make_model_year, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:automobile_fuel].same_as? characteristics[:make_model_year].automobile_fuel
                  characteristics[:make_model_year].fuel_efficiency_city
                elsif characteristics[:automobile_fuel].same_as? characteristics[:make_model_year].alt_automobile_fuel
                  characteristics[:make_model_year].alt_fuel_efficiency_city
                end
            end
            
            # Otherwise check whether `automobile fuel` is the `make model` primary or secondary fuel and use the appropriate city fuel efficiency (*km / l*).
            quorum 'from make model and automobile fuel', :needs => [:make_model, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:automobile_fuel].same_as? characteristics[:make_model].automobile_fuel
                  characteristics[:make_model].fuel_efficiency_city
                elsif characteristics[:automobile_fuel].same_as? characteristics[:make_model].alt_automobile_fuel
                  characteristics[:make_model].alt_fuel_efficiency_city
                end
            end
          end
          
          #### Fuel efficiency highway (*km / l*)
          # *The automobile's highway fuel efficiency.*
          committee :fuel_efficiency_highway do
            # Use client input, if available.
            
            # Otherwise check whether `automobile fuel` is the `make model year` primary or secondary fuel and use the appropriate highway fuel efficiency (*km / l*).
            quorum 'from make model year and automobile fuel', :needs => [:make_model_year, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:automobile_fuel].same_as? characteristics[:make_model_year].automobile_fuel
                  characteristics[:make_model_year].fuel_efficiency_highway
                elsif characteristics[:automobile_fuel].same_as? characteristics[:make_model_year].alt_automobile_fuel
                  characteristics[:make_model_year].alt_fuel_efficiency_highway
                end
            end
            
            # Otherwise check whether `automobile fuel` is the `make model` primary or secondary fuel and use the appropriate highway fuel efficiency (*km / l*).
            quorum 'from make model and automobile fuel', :needs => [:make_model, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:automobile_fuel].same_as? characteristics[:make_model].automobile_fuel
                  characteristics[:make_model].fuel_efficiency_highway
                elsif characteristics[:automobile_fuel].same_as? characteristics[:make_model].alt_automobile_fuel
                  characteristics[:make_model].alt_fuel_efficiency_highway
                end
            end
          end
          
          #### Automobile fuel
          # *The automobile's [fuel type](http://data.brighterplanet.com/automobile_fuels).*
          committee :automobile_fuel do
            # Use client input, if available.
            
            # Otherwise use the `make model year` automobile fuel.
            quorum 'from make model year', :needs => :make_model_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_model_year].automobile_fuel
            end
            
            # Otherwise use the `make model` automobile fuel.
            quorum 'from make model', :needs => :make_model,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_model].automobile_fuel
            end
            
            # Otherwise use the average automobile fuel.
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso] do
                AutomobileFuel.fallback
            end
          end
          
          #### Hybridity multiplier (*dimensionless*)
          # *A multiplier to adjust fuel efficiency based on whether the automobile is a hybrid or conventional vehicle.*
          committee :hybridity_multiplier do
            # Check whether the `size class` has `hybridity` multipliers for city and highway fuel efficiency.
            # If it does, calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from size class, hybridity, and urbanity', :needs => [:size_class, :hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = (characteristics[:hybridity] == true) ? :hybrid : :conventional
                city_multiplier    = characteristics[:size_class].send(:"#{drivetrain}_fuel_efficiency_city_multiplier")
                highway_multiplier = characteristics[:size_class].send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                
                if city_multiplier and highway_multiplier
                  1.0 / ((characteristics[:urbanity] / city_multiplier) + ((1.0 - characteristics[:urbanity]) / highway_multiplier))
                end
            end
            
            # Otherwise look up the average [size class](http://data.brighterplanet.com/automobile_size_classes) `hybridity` multipliers for city and highway fuel efficiency.
            # Calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from hybridity and urbanity', :needs => [:hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = (characteristics[:hybridity] == true) ? :hybrid : :conventional
                city_multiplier = AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier")
                highway_multiplier = AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                
                1.0 / ((characteristics[:urbanity] / city_multiplier) + ((1.0 - characteristics[:urbanity]) / highway_multiplier))
            end
            
            # Otherwise use a multiplier of 1.0.
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                1.0
            end
          end
          
          #### Hybridity (*boolean*)
          # *True if the automobile is a hybrid vehicle. False if the automobile is a conventional vehicle.*
          #
          # Use client input, if available.
          
          #### Size class
          # *The automobile's [size class](http://data.brighterplanet.com/automobile_size_classes).*
          #
          # Use client input, if available.
          
          #### Urbanity (*%*)
          # *The fraction of the total distance driven that is in towns and cities rather than highways.*
          # Highways are defined as roads with a speed limit of 45 miles per hour or more.
          committee :urbanity do
            # Use client input, if available.
            
            # Otherwise use the `country` average automobile urbanity (*%*).
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:country].automobile_urbanity
            end
            
            # Otherwise use the global average automobile urbanity (*%*).
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                Country.fallback.automobile_urbanity
            end
          end
          
          #### Country
          # *The [country](http://data.brighterplanet.com/countries) in which the trip occurred.*
          #
          # Use client input, if available.
          
          #### Active subtimeframe (*date range*)
          # *The portion of `timeframe` that falls between `acquisition` and `retirement`.*
          committee :active_subtimeframe do
            # Calculate the portion of `timeframe` that falls between `acqusition` and `retirement`.
            # If there is no overlap then `active subtimeframe` is zero days.
            quorum 'from acquisition and retirement', :needs => [:acquisition, :retirement],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                if characteristics[:acquisition].value <= characteristics[:retirement].value
                  Timeframe.constrained_new characteristics[:acquisition].to_date, characteristics[:retirement].to_date, timeframe
                else
                  Timeframe.constrained_new characteristics[:retirement].to_date, characteristics[:retirement].to_date, timeframe
                end
            end
          end
          
          #### Acquisition (*date*)
          # *The date the automobile was put into use.*
          committee :acquisition do
            # Use client input, if available.
            
            # Otherwise use the first day of `year`.
            quorum 'from year', :needs => :year,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                Date.new characteristics[:year].year, 1, 1
            end
            
            # Otherwise use whichever is earlier: the first day of `timeframe` or `retirement`.
            quorum 'from timeframe and retirement', :needs => :retirement,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                [ timeframe.from, characteristics[:retirement] ].compact.min
            end
          end
          
          #### Retirement (*date*)
          # *The date the automobile was taken out of use.*
          committee :retirement do
            # Use client input, if available.
            
            # Otherwise use whichever is later: the last day of `timeframe` or `acquisition` (if we know it).
            quorum 'from timeframe', :appreciates => :acquisition,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                [ timeframe.to, characteristics[:acquisition] ].compact.max
            end
          end
          
          #### Make model year
          # *The automobile's [make, model, and year](http://data.brighterplanet.com/automobile_make_model_years).*
          #
          # Match client input to a record in our database.
          
          #### Make year
          # *The automobile's [make and year](http://data.brighterplanet.com/automobile_make_years).*
          committee :make_year do
            # Match `make` and `year` to a record in our database.
            quorum 'from make and year', :needs => [:make, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeYear.find_by_make_name_and_year(characteristics[:make].name, characteristics[:year].year)
            end
          end
          
          #### Make model
          # *The automobile's [make and model](http://data.brighterplanet.com/automobile_make_models).*
          #
          # Match client input to a record in our database.
          
          #### Year
          # *The automobile's [year of manufacture](http://data.brighterplanet.com/automobile_years).*
          #
          # Use client input, if available.
          
          #### Model
          # *The automobile's [model](http://data.brighterplanet.com/automobile_models).*
          #
          # Use client input, if available.
          
          #### Make
          # *The automobile's [make](http://data.brighterplanet.com/automobile_makes).*
          #
          # Use client input, if available.
        end
      end
    end
  end
end
