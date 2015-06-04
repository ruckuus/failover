require File.join(File.dirname(__FILE__), '../base/decision_worker')
require 'yaml'

module Failover
  class Worker::Decision::Dummy < Worker::Decision

    def load_stat
      @mystate = YAML.load_file(@config.state_file)
    end

    # Get instance score, read from state_file
    def get_instance_score(instance_id)
      state = @mystate
      score = 0

      return nil if @mystate == nil
      instance_data = @mystate[instance_id]

      instance_data.each do |srv, srv_score|
        score += srv_score
      end

      score
    end

    def get_scores
      self.load_stat

      groups = @config.groups


      end
      active = @mystate['active_instance']
      candidate = @mystate['candidate']
      score_active = 0
      score_passive = 0

      # Calculate ACTIVE score
      stats = @mystate[active]
      stats.each do |service, status|
        score_active += status
      end

      # Calculate pair's ACTIVE score
      stats = @mystate[self.get_instance_pair(active)[0]]
      stats.each do |service, status|
        score_active += status
      end

      # Calculate passive score
      stats = @mystate[candidate]
      stats.each do |service, status|
        score_passive += status
      end

      # Calculate pair's PASSIVE score
      stats = @mystate[self.get_instance_pair(candidate)[0]]
      stats.each do |service, status|
        score_passive += status
      end

      self.bucket['active_score'] = score_active
      self.bucket['passive_score'] = score_passive
    end
  end
end
