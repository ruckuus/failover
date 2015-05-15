module Failover
  class Provider
    attr_accessor :provider
    attr_accessor :name
    attr_accessor :config
    attr_accessor :status

    def initialize(config)
      @config = config
      @provider = nil
      @name = nil
      @status = nil
    end
  end
end
