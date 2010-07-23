require 'summary_judgement'

module BrighterPlanet
  module Automobile
    module Summarization
      def self.included(base)
        base.summarize do |has|
          has.adjective :model_year
          has.adjective :make
          has.adjective :model
          has.identity 'automobile'
          has.verb :own
        end
      end
    end
  end
end
