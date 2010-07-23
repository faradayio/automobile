module BrighterPlanet
  module Automobile
    extend self

    def included(base)
      require 'cohort_scope'
      require 'falls_back_on'
      require 'falls_back_on/active_record_ext'

      require 'automobile/carbon_model'
      require 'automobile/characterization'
      require 'automobile/data'
      require 'automobile/summarization'

      base.send :include, BrighterPlanet::Automobile::CarbonModel
      base.send :include, BrighterPlanet::Automobile::Data
      base.send :include, BrighterPlanet::Automobile::Summarization
      base.send :include, BrighterPlanet::Automobile::Characterization
    end
    def automobile_model
      if Object.const_defined? 'Automobile'
        ::Automobile
      elsif Object.const_defined? 'AutomobileRecord'
        AutomobileRecord
      else
        raise 'There is no automobile model'
      end
    end
  end
end
