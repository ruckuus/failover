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
    attr_reader :loadbalance_group

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
      @loadbalance_group = config['loadbalance_group']
      @config = config
      @score = Hash.new
    end

    def get_secret_access_key
      return @keys.each do |k|
        return k['secret_access_key'] if k['secret_access_key']
      end
    end

    def get_access_key_id
      return @keys.each do |k|
        return k['access_key_id'] if k['access_key_id']
      end
    end

    def get_scores
      @services.each do |zone|
        zone.each do |name, s|
          tmp = zone[name]
          tmp.each do |item|
            @score["#{item['name']}"] = item['score']
          end
        end
      end

      @score
    end

    def get_services(zone_name)
      value = []

      @services.each do |zone|
        if zone[zone_name]
          tmp = zone[zone_name]
          tmp.each do |name|
            value << name['name']
          end
        end
      end

      value
    end

    def dump_config
      @config
    end
  end
end
