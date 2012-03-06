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
            # Multiply `fuel use` (*l*) by the `automobile fuel` co2 emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_emission_factor
            end
          end
          
          #### CO<sub>2</sub> biogenic emission (*kg*)
          # *The automobile's CO<sub>2</sub> emissions from biogenic sources during `active subtimeframe`.*
          committee :co2_biogenic_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` co2 biogenic emission factor (*kg / l*) to give *kg*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].co2_biogenic_emission_factor
            end
          end
          
          #### CH<sub>4</sub> emission (*kg CO<sub>2</sub>e*)
          # *The automobile's CH<sub>4</sub> emissions during `active subtimeframe`.*
          committee :ch4_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` ch4 emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].ch4_emission_factor
            end
          end
          
          #### N<sub>2</sub>O emission (*kg CO<sub>2</sub>e*)
          # *The automobile's N<sub>2</sub>O emissions during `active subtimeframe`.*
          committee :n2o_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` n2o emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].n2o_emission_factor
            end
          end
          
          #### HFC emission (*kg CO<sub>2</sub>e*)
          # *The automobile's HFC emissions during `active subtimeframe`.*
          committee :hfc_emission do
            # Multiply `fuel use` (*l*) by the `automobile fuel` hfc emission factor (*kg CO<sub>2</sub>e / l*) to give *kg CO<sub>2</sub>e*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:fuel_use] * characteristics[:automobile_fuel].hfc_emission_factor
            end
          end
          
          #### Energy (*MJ*)
          # *The automobile's energy use during `active subtimeframe`.*
          committee :energy do
            # Multiply `fuel use` (*l*) by the `automobile fuel` energy content (*MJ / l*) to give *MJ*.
            quorum 'from fuel use and automobile fuel', :needs => [:fuel_use, :automobile_fuel] do |characteristics|
              characteristics[:fuel_use] * characteristics[:automobile_fuel].energy_content
            end
          end
          
          #### Fuel use (*l*)
          # *The automobile's fuel use during `active subtimeframe`.*
          committee :fuel_use do
            # Use client input, if available.
            
            # Otherwise divide `distance` (*km*) by `fuel efficiency` (*km / l*) to give *l*.
            quorum 'from fuel efficiency and distance', :needs => [:fuel_efficiency, :distance],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:distance] / characteristics[:fuel_efficiency]
            end
          end
          
          #### Distance (*km*)
          # *The distance the automobile travelled during `active subtimeframe`.*
          committee :distance do
            # Multiply `annual distance` (*km*) by the fraction of the calendar year in which `timeframe` falls that overlaps with `active subtimeframe` to give *km*.
            quorum 'from annual distance', :needs => [:annual_distance, :active_subtimeframe],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:annual_distance] * (characteristics[:active_subtimeframe] / timeframe.year)
            end
          end
          
          #### Annual distance (*km*)
          # *The distance the automobile would travel if it were used for the entire calendar year in which `timeframe` falls.*
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
            
            # Otherwise divide `daily duration` (*seconds*) by 3600 (*seconds / hour*) and multiply by `speed` (*km / hour*) to give *km*.
            # Multiply by the number of days in the calendar year in which `timeframe` falls to give *km*.
            quorum 'from daily duration, speed, and timeframe', :needs => [:daily_duration, :speed],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                characteristics[:daily_duration] / 3600.0 * characteristics[:speed] * timeframe.year.days
            end
            
            # Otherwise use the `size class` annual distance (*km*).
            quorum 'from size class', :needs => :size_class,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:size_class].annual_distance
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
          
          #### Daily duration (*seconds*)
          # *The average time the automobile is driven each day.*
          #
          # Use client input, if available.
          
          #### Automobile fuel
          # *The automobile's [fuel type](http://data.brighterplanet.com/automobile_fuels).*
          committee :automobile_fuel do
            # Use client input, if available.
            
            # Otherwise use the `make model year` [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            quorum 'from make model year', :needs => :make_model_year,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_model_year].automobile_fuel
            end
            
            # Otherwise use the average [automobile fuel](http://data.brighterplanet.com/automobile_fuels).
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileFuel.fallback
            end
          end
          
          #### Speed (*km / hour*)
          # *The automobile's average speed.*
          committee :speed do
            # Use client input, if available.
            
            # Otherwise look up the `safe country` average automobile city speed (*km / hour*) and automobile highway speed (*km / hour*).
            # Calculate the harmonic mean of those speeds weighted by `urbanity` to give *km / hour*.
            quorum 'from urbanity and safe country', :needs => [:urbanity, :safe_country],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1 / (characteristics[:urbanity] / characteristics[:safe_country].automobile_city_speed + (1 - characteristics[:urbanity]) / characteristics[:safe_country].automobile_highway_speed)
            end
          end
          
          #### Fuel efficiency (*km / l*)
          # *The automobile's fuel efficiency.*
          committee :fuel_efficiency do
            # Use client input, if available.
            
            # Otherwise look up the `make model year` fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model year and urbanity', :needs => [:make_model_year, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1.0 / (
                  (characteristics[:urbanity]         / characteristics[:make_model_year].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:make_model_year].fuel_efficiency_highway)
                )
            end
            
            # Otherwise look up the `make model` fuel efficiency city (*km / l*) and fuel efficiency highway (*km / l*).
            # Calculate the harmonic mean of those fuel efficiencies, weighted by `urbanity`, to give *km / l*.
            quorum 'from make model and urbanity', :needs => [:make_model, :urbanity],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                1.0 / (
                  (characteristics[:urbanity]         / characteristics[:make_model].fuel_efficiency_city) +
                  ((1.0 - characteristics[:urbanity]) / characteristics[:make_model].fuel_efficiency_highway)
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
            
            # Otherwise look up the `make year` fuel efficiency (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make year and hybridity multiplier', :needs => [:make_year, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make_year].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `make` fuel efficiency (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from make and hybridity multiplier', :needs => [:make, :hybridity_multiplier],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:make].fuel_efficiency * characteristics[:hybridity_multiplier]
            end
            
            # Otherwise look up the `safe country` average `automobile fuel efficiency` (*km / l*).
            # Multiply by `hybridity multiplier` to give *km / l*.
            quorum 'from hybridity multiplier and safe country', :needs => [:hybridity_multiplier, :safe_country],
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:safe_country].automobile_fuel_efficiency * characteristics[:hybridity_multiplier]
            end
          end
          
          #### Hybridity multiplier (*dimensionless*)
          # *A multiplier used to adjust fuel efficiency if we know the automobile is a hybrid or conventional vehicle.*
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
          # Highways are defined as all driving at speeds of 45 miles per hour or greater.
          committee :urbanity do
            # Use the `safe country` average automobile urbanity (*%*).
            quorum 'from safe country', :needs => :safe_country,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                characteristics[:safe_country].automobile_urbanity
            end
          end
          
          #### Safe country
          # *Ensure that `country` has all needed values.*
          committee :safe_country do
            # Confirm that the client-input `country` has all the needed values.
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                if [:automobile_city_speed, :automobile_highway_speed, :automobile_urbanity, :automobile_fuel_efficiency].all? { |required_attr| characteristics[:country].send(required_attr).present? }
                  characteristics[:country]
                end
            end
            
            # Otherwise use an artificial country that contains global averages.
            quorum 'default',
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do
                Country.fallback
            end
          end
          
          #### Country
          # *The [country](http://data.brighterplanet.com/countries) in which the trip occurred.*
          #
          # Use client input, if available.
          
          #### Active subtimeframe (*date range*)
          # *The portion of `timeframe` that falls between `acquisition` and `retirement`.*
          committee :active_subtimeframe do
            # Calculate the portion of `timeframe` that falls between `acqusition` and `retirement` (*date range*).
            # If there is no overlap then we don't know active subtimeframe.
            quorum 'from acquisition and retirement', :needs => [:acquisition, :retirement],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                Timeframe.constrained_new characteristics[:acquisition].to_date, characteristics[:retirement].to_date, timeframe
            end
          end
          
          #### Acquisition (*date*)
          # *The date the automobile was put into use.*
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
          # *The date the automobile was taken out of use.*
          committee :retirement do
            # Use client input, if available.
            
            # Otherwise use whichever is later: the last day of `timeframe` or `acquisition` (if we know it).
            quorum 'default', :appreciates => :acquisition,
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                [ timeframe.to, characteristics[:acquisition] ].compact.max
            end
          end
          
          #### Make model year
          # *The automobile's [make, model, and year](http://data.brighterplanet.com/automobile_make_model_years).*
          committee :make_model_year do
            # Check whether the `make`, `model`, and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know make model year.
            quorum 'from make, model, and year', :needs => [:make, :model, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModelYear.find_by_make_name_and_model_name_and_year(characteristics[:make].name, characteristics[:model].name, characteristics[:year].year)
            end
          end
          
          #### Make year
          # *The automobile's [make and year](http://data.brighterplanet.com/automobile_make_years).*
          committee :make_year do
            # Check whether the `make` and `year` combination matches any automobiles in our database.
            # If it doesn't then we don't know make year.
            quorum 'from make and year', :needs => [:make, :year],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeYear.find_by_make_name_and_year(characteristics[:make].name, characteristics[:year].year)
            end
          end
          
          #### Make model
          # *The automobile's [make and model](http://data.brighterplanet.com/automobile_make_models).*
          committee :make_model do
            # Check whether the `make` and `model` combination matches any automobiles in our database.
            # If it doesn't then we don't know make model.
            quorum 'from make and model', :needs => [:make, :model],
              :complies => [:ghg_protocol_scope_1, :ghg_protocol_scope_3, :iso] do |characteristics|
                AutomobileMakeModel.find_by_make_name_and_model_name(characteristics[:make].name, characteristics[:model].name)
            end
          end
          
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
