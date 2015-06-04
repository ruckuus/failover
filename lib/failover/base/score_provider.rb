require File.join(File.dirname(__FILE__), '../provider')
require 'yaml'

module Failover
  class Provider::Score < Provider
    def calculate_score
      # Get total score for active and passive group
    end
  end
end
