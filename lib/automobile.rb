require 'emitter'

module BrighterPlanet
  module Automobile
    extend BrighterPlanet::Emitter

    def self.automobile_model
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
