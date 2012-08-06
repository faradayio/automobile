require 'emitter'

require 'automobile/impact_model'
require 'automobile/characterization'
require 'automobile/data'
require 'automobile/relationships'
require 'automobile/summarization'

module BrighterPlanet
  module Automobile
    extend BrighterPlanet::Emitter
    scope 'The automobile emission estimate is the total anthropogenic emissions from fuel and air conditioning used by the automobile during the timeframe. It includes CO2 emissions from combustion of non-biogenic fuel, CH4 and N2O emissions from combustion of all fuel, and fugitive HFC emissions from air conditioning. For vehicles powered by grid electricity it includes the emissions from generating that electricity.'
  end
end
