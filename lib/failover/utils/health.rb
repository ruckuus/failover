module Failover
  module Health
    @@health = Hash.new

    def self.set(key, value)
      @@health[key] = value
    end

    def self.get
      @@health
    end
  end
end
