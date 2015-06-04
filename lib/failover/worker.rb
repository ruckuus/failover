require_relative 'utils/health'

module Failover
  class Worker
    attr_accessor :health
    attr_accessor :provider
    attr_accessor :status
    attr_accessor :score
    attr_accessor :bucket # general purpose data holder

    # Parameter must be an instance of provider
    def initialize(provider)
      if !provider.kind_of?(Provider)
        raise 'You must pass an instance of Provider here'
      end

      @config = provider.config
      @state_file = provider.config.state_file
      @provider = provider
      @status = Hash.new
      @score = provider.config.get_scores
      @bucket = Hash.new
    end

    def start
    end

    def stop
      self.save
    end

    def save
      File.open(@state_file, 'w') { |f| f.write Failover::Health.get.to_yaml }
    end
  end
end
