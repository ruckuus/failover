require 'yaml'

module Failover
  class Config

    attr_reader :keys
    attr_reader :score
    attr_reader :groups
    attr_reader :region
    attr_reader :ha_type
    attr_reader :log_file
    attr_reader :services
    attr_reader :instances
    attr_reader :state_file
    attr_reader :elastic_ip
    attr_reader :cloud_provider
    attr_reader :load_balancers
    attr_reader :service_provider

    def initialize(config_file)
      config = YAML.load_file(config_file)

      @keys = config['keys']
      @score = config['score']
      @region = config['region']
      @groups = config['groups']
      @ha_type = config['ha_type']
      @log_file = config['log_file']
      @services = config['services']
      @instances = config['instances']
      @state_file = config['state_file']
      @elastic_ip = config['elastic_ip']
      @cloud_provider = config['cloud_provider']
      @load_balancers = config['load_balancers']
      @service_provider = config['service_provider']
      @config = config
    end

    def dump_config
      @config
    end
  end
end
