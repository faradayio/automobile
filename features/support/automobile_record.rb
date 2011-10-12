require 'active_record'
require 'falls_back_on'
require 'automobile'
require 'sniff'

class AutomobileRecord < ActiveRecord::Base
  include BrighterPlanet::Emitter
  include BrighterPlanet::Automobile
end
