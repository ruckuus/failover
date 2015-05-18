require File.join(File.dirname(__FILE__), '../provider')

module Failover
  # The Provider::Cloud class serves as an abstract base class
  # for all other Cloud provider class. You should not instantiate this class directly.
  class Provider::Cloud < Provider

    def get_active_instance
    end

    def get_candidate_instance
    end
  end
end
