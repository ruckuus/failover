module Failover
  class Provider
    attr_accessor :provider
    attr_accessor :name
    attr_accessor :config
    attr_accessor :status

    def initialize(config)
      if !config.kind_of?(Config)
        raise 'You must pass an instance of Config here'
      end

      @config = config
      @provider = nil
      @name = nil
      @status = Hash.new
    end
  end
end
