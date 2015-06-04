require File.join(File.dirname(__FILE__), '../worker')

module Failover
  class Worker::Decision < Worker

    # Make decision based on given score
    def do_failover
      begin
        # provider.failover
        # DEBUG! Commented out now
        puts "Failover => provider.failover"
      rescue Exception => e
        raise e
      end
    end

    def make_decision(active_score, passive_score)
      # False, do nothing
      return false if active_score <= passive_score

      # True, do failover
      if active_score > passive_score
        self.do_failover
        return true
      end
    end

    def get_scores
      if self.bucket.kind_of?(nil)
        self.bucket = Hash.new
      end

      # This should be overridden
      self.bucket['active'] = 0;
      self.bucket['passive'] = 0;
    end

    def do_decide
      active_score = 0
      passive_score = 0

      # Do some logic
      self.get_scores

      active_score = self.bucket['active'] if self.bucket['active']
      passive_score = self.bucket['passive'] if self.bucket['passive']

      if make_decision(active_score, passive_score) === false
        "Normal"
      else
        puts "Failover is happening. Log it."
      end
    end
  end
end
