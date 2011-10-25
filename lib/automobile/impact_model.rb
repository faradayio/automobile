# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

### Automobile impact model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s [CM1 web service](http://carbon.brighterplanet.com) to calculate the impacts of an automobile, such as energy use and greenhouse gas emissions.

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
# * **value returned** (***units of measurement***)
# * a description of the value
# * calculation methods, listed from most to least preferred
#
# Some methods need `values` returned by prior calculations. If any of these `values` are unknown the method is skipped.
# If all of the methods for a calculation are skipped, the value the calculation would return is unknown.

##### Standard compliance
# When compliance with a particular standard is requested, all methods that do not comply with that standard are ignored.
# Thus any `values` a method needs will have been calculated using a compliant method or will be unknown.
# To see which standards a method complies with, check the `:complies =>` section of the code in the right column.
# Client input complies with all standards.

##### Collaboration
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module Automobile
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          # * * *
          
          #### Greenhouse gas emissions (*kg CO<sub>2</sub>e*)
          # The automobile's total greenhouse gas emissions from anthropogenic sources during `active subtimeframe`.
          committee :carbon do
            # Sum `co2 emission` (*kg*), `ch4 emission` (*kg CO<sub>2</sub>e*), `n2o emission` (*kg CO<sub>2</sub>e*), and `hfc emission` (*kg CO<sub>2</sub>e*), to give *kg CO<sub>2</sub>e*.
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission', :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
          end
          
          #### CO<sub>2</sub> emission (*kg*)
          # The automobile's CO<sub>2</sub> emissions from anthropogenic sources during `active subtimeframe`.
          committee :co2_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s co2 emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_emission_factor
            end
          end
          
          #### CO<sub>2</sub> biogenic emission (*kg*)
          # The automobile's CO<sub>2</sub> emissions from biogenic sources during `active subtimeframe`.
          committee :co2_biogenic_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s co2 biogenic emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_biogenic_emission_factor
            end
          end
          
          #### CH<sub>4</sub> emission (*kg CO<sub>2</sub>e*)
          # The automobile's CH<sub>4</sub> emissions during `active subtimeframe`.
          committee :ch4_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s ch4 emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].ch4_emission_factor
            end
          end
          
          #### N<sub>2</sub>O emission (*kg CO<sub>2</sub>e*)
          # The automobile's N<sub>2</sub>O emissions during `active subtimeframe`.
          committee :n2o_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s n2o emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].n2o_emission_factor
            end
          end
          
          #### HFC emission (*kg CO<sub>2</sub>e*)
          # The automobile's HFC emissions during `active subtimeframe`.
          committee :hfc_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s hfc emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].hfc_emission_factor
            end
          end
          
          #### Energy use (*MJ*)
          # The automobile's energy use during `active subtimeframe`.
          committee :energy do
            # Multiply `fuel use` (*l*) by the `automobile fuel`'s energy content (*MJ / l*) to give *MJ*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel] do |characteristics|
              characteristics[:fuel_use] * characteristics[:automobile_fuel].energy_content
            end
          end
          
          #### Fuel use (*l*)
          # The automobile's fuel use during `active subtimeframe`.
          committee :fuel_use do
            # Use client input, if available.
            
            # Otherwise divide `distance` (*km*) by `fuel efficiency` (*km / l*) to give *l*.
            quorum 'from fuel efficiency and distance', :needs => [:fuel_efficiency, :distance],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:distance] / characteristics[:fuel_efficiency]
            end
          end
          
          #### Distance (*km*)
          # The distance the automobile travelled during `active subtimeframe`.
          committee :distance do
            # Multiply `annual distance` (*km*) by the fraction of the calendar year in which `timeframe` falls that overlaps with `active subtimeframe` to give *km*.
            quorum 'from annual distance', :needs => [:annual_distance, :active_subtimeframe],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:annual_distance] * (characteristics[:active_subtimeframe] / timeframe.year)
            end
          end
          
          #### Annual distance (*km*)
          # The distance the automobile would travel if it were used for the entire calendar year in which `timeframe` falls.
          # Note that this will be **more** than the actual distance traveled if the automobile was not in use for the entire calendar year (if either `acquisition` or `retirement` occurs during the calendar year in which `timeframe` falls).
          committee :annual_distance do
            # Use client input, if available.
            
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
            
            # Otherwise multiply `daily duration` (*seconds*) by `speed` (*km / hour*) to give *km*.
            # Multiply by the number of days in the calendar year in which `timeframe` falls to give *km*.
            quorum 'from daily duration, speed, and timeframe', :needs => [:daily_duration, :speed],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:daily_duration] / 3600.0 * characteristics[:speed] * timeframe.year.days
            end
            
            # Otherwise look up the `size class`' annual distance (*km*).
            quorum 'from size class', :needs => :size_class,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:size_class].annual_distance
            end
            
            # Otherwise look up the `automobile fuel`'s annual distance (*km*).
            quorum 'from automobile fuel', :needs => :automobile_fuel,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:automobile_fuel].annual_distance
            end
          end
          
          #### Weekly distance (*km*)
          # The average distance the automobile is driven each week.
          #
          # Use client input if available.
          
          #### Daily distance (*km*)
          # The average distance the automobile is driven each day.
          #
          # Use client input if available.
          
          #### Daily duration (*seconds*)
          # The average time the automobile is driven each day.
          #
          # Use client input, if available.
          
          #### Automobile fuel
          # The automobile's [fuel type](http://data.brighterplanet.com/automobile_fuels).
          committee :automobile_fuel do
            # Use client input, if available.
            
            # Otherwise look up the average [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileFuel.fallback
            end
          end
          
          #### Speed (*km / hr*)
          # The automobile's average speed.
          committee :speed do
            # Use client input, if available.
            
            # Otherwise look up the [United States](http://data.brighterplanet.com/countries)' average automobile city speed (*km / hr*) and automobile highway speed (*km / hr*).
            # Calculate the harmonic mean of those speeds weighted by `urbanity` to give *km / hr*.
            quorum 'from urbanity', :needs => :urbanity,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1 / (characteristics[:urbanity] / Country.united_states.automobile_city_speed + (1 - characteristics[:urbanity]) / Country.united_states.automobile_highway_speed)
            end
          end
          
          #### Fuel efficiency (*km / l*)
          # The automobile's fuel efficiency.
          committee :fuel_efficiency do
            # Use client input, if available.
            
            # Otherwise look up the `make model year`'s fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model year and urbanity', :needs => [:make_model_year, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                fuel_efficiency_city = characteristics[:make_model_year].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model_year].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            # Otherwise look up the `make model`'s fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model and urbanity', :needs => [:make_model, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                fuel_efficiency_city = characteristics[:make_model].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:make_model].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))
                end
            end
            
            # Otherwise look up the `size class`' `fuel efficiency city`(*km / l*) and `fuel efficiency highway` (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from size class, hybridity multiplier, and urbanity', :needs => [:size_class, :hybridity_multiplier, :urbanity],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                fuel_efficiency_city = characteristics[:size_class].fuel_efficiency_city
                fuel_efficiency_highway = characteristics[:size_class].fuel_efficiency_highway
                urbanity = characteristics[:urbanity]
                if fuel_efficiency_city.present? and fuel_efficiency_highway.present?
                  (1.0 / ((urbanity / fuel_efficiency_city) + ((1.0 - urbanity) / fuel_efficiency_highway))) * characteristics[:hybridity_multiplier]
                end
            end
            
            # Otherwise look up the `make year`'s `fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make year and hybridity multiplier', :needs => [:make_year, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `make`'s `fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make and hybridity multiplier', :needs => [:make, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                if characteristics[:make].fuel_efficiency.present?
                  characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
                end
            end
            
            # Otherwise look up the [United States](http://data.brighterplanet.com/countries)' average `automobile fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from hybridity multiplier', :needs => :hybridity_multiplier,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                Country.united_states.automobile_fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          #### Hybridity multiplier (*dimensionless*)
          # A multiplier used to adjust fuel efficiency if we know the automobile is a hybrid or conventional vehicle.
          committee :hybridity_multiplier do
            # Check whether the `size class` has `hybridity` multipliers for city and highway fuel efficiency.
            # If it does, calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from size class, hybridity, and urbanity', :needs => [:size_class, :hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
                urbanity = characteristics[:urbanity]
                size_class = characteristics[:size_class]
                fuel_efficiency_multipliers = {
                  :city => size_class.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                  :highway => size_class.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                }
                if fuel_efficiency_multipliers.values.all?(&:present?)
                  1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
                end
            end
            
            # Otherwise look up the `hybridity`'s average city and highway fuel efficiency multipliers.
            # Calculate the harmonic mean of those multipliers, weighted by `urbanity`.
            quorum 'from hybridity and urbanity', :needs => [:hybridity, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                drivetrain = characteristics[:hybridity] ? :hybrid : :conventional
                urbanity = characteristics[:urbanity]
                fuel_efficiency_multipliers = {
                  :city => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_city_multiplier"),
                  :highway => AutomobileSizeClass.fallback.send(:"#{drivetrain}_fuel_efficiency_highway_multiplier")
                }
                1.0 / ((urbanity / fuel_efficiency_multipliers[:city]) + ((1.0 - urbanity) / fuel_efficiency_multipliers[:highway]))
            end
            
            # Otherwise use a multiplier of 1.0.
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                1.0
            end
          end
          
          #### Hybridity (*boolean*)
          # True if the automobile is a hybrid vehicle. False if the automobile is a conventional vehicle.
          #
          # Use client input, if available.
          
          #### Size class
          # The automobile's [size class](http://data.brighterplanet.com/automobile_size_classes).
          #
          # Use client input, if available.
          
          #### Urbanity (*%*)
          # The fraction of the total distance driven that is in towns and cities rather than highways.
          # Highways are defined as all driving at speeds of 45 miles per hour or greater.
          committee :urbanity do
            # Look up the [United States](http://data.brighterplanet.com/countries)'s average `automobile urbanity` (*%*).
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                Country.united_states.automobile_urbanity
            end
          end
          
          #### Active subtimeframe (*date range*)
          # The portion of `timeframe` that falls between `acquisition` and `retirement`.
          committee :active_subtimeframe do
            # Calculate the portion of `timeframe` that falls between `acqusition` and `retirement` (*date range*).
            # If there is no overlap then we don't know `active subtimeframe`.
            quorum 'from acquisition and retirement', :needs => [:acquisition, :retirement],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                Timeframe.constrained_new characteristics[:acquisition].to_date, characteristics[:retirement].to_date, timeframe
            end
          end
          
          #### Acquisition (*date*)
          # The date the automobile was put into use.
          committee :acquisition do
            # Use client input, if available.
            
            # Otherwise use the first day of `year` (*date*).
            quorum 'from year', :needs => :year,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                Date.new characteristics[:year].year, 1, 1
            end
            
            # Otherwise use whichever is earlier: the first day of `timeframe` or `retirement`.
            quorum 'default', :appreciates => :retirement,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                [ timeframe.from, characteristics[:retirement] ].compact.min
            end
          end
          
          #### Retirement (*date*)
          # The date the automobile was taken out of use.
          committee :retirement do
            # Use client input, if available.
            
            # Otherwise use whichever is later: the last day of `timeframe` or `acquisition` (if we know it).
            quorum 'default', :appreciates => :acquisition,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                [ timeframe.to, characteristics[:acquisition] ].compact.max
            end
          end
          
          #### Make model year
          # The automobile's [make, model, and year](http://data.brighterplanet.com/automobile_make_model_years).
          committee :make_model_year do
            # Check whether the `make`, `model`, and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make model year`.
            quorum 'from make, model, and year', :needs => [:make, :model, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModelYear.find_by_make_name_and_model_name_and_year(characteristics[:make].name, characteristics[:model].name, characteristics[:year].year)
            end
          end
          
          #### Make year
          # The automobile's [make and year](http://data.brighterplanet.com/automobile_make_years).
          committee :make_year do
            # Check whether the `make` and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make year`.
            quorum 'from make and year', :needs => [:make, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeYear.find_by_make_name_and_year(characteristics[:make].name, characteristics[:year].year)
            end
          end
          
          #### Make model
          # The automobile's [make and model](http://data.brighterplanet.com/automobile_make_models).
          committee :make_model do
            # Check whether the `make` and `model` combination matches any automobiles in our database.
            # If it doesn't then we don't know `make model`.
            quorum 'from make and model', :needs => [:make, :model],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModel.find_by_make_name_and_model_name(characteristics[:make].name, characteristics[:model].name)
            end
          end
          
          #### Year
          # The automobile's [year of manufacture](http://data.brighterplanet.com/automobile_years).
          #
          # Use client input, if available.
          
          #### Model
          # The automobile's [model](http://data.brighterplanet.com/automobile_models).
          #
          # Use client input, if available.
          
          #### Make
          # The automobile's [make](http://data.brighterplanet.com/automobile_makes).
          #
          # Use client input, if available.
        end
      end
    end
  end
end
