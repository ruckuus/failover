require_relative '../utils/health'

module Failover
  class Worker::Cloud < Worker
    def get_active_instance
      return provider.get_active_instance
    end

    def get_candidate_instance
      return provider.get_candidate_instance
    end

    def start
      Failover::Health.set('active_instance', get_active_instance)
      Failover::Health.set('candidate', get_candidate_instance)
    end
  end
end
