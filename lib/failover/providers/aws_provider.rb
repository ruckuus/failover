require_relative '../base/cloud_provider'
require_relative '../utils/awsutil'
require 'yaml'

module Failover
  class Provider::Cloud::Aws < Provider::Cloud

    def get_active_instance
      util = Awsutil.new(@config)
      # Get HA Setup (EIP or ELB)
      ha_type = @config.ha_type
      res = nil

      begin
        if ha_type == 'eip'
          res = util.get_active_instance_by_eip(@config.elastic_ip)
        elsif ha_type == 'elb'
          res = util.get_active_instance_by_elb(@config.elb_name)
        else
          raise "HA Type #{ha_type} is not supported."
        end

        # Store it in :status
        self.status['active_instance'] = res
        return res
      rescue Exception => e
        raise e
        nil
      end
    end

    def get_candidate_instance
      # This will be a problem after failover
      ec2 = nil
      loadbalance_group = @config.loadbalance_group

      return nil if self.status.nil? || self.status['active_instance'].nil?

      @config.groups.each do |grp|
        grp[loadbalance_group].each do |ec2|
          return ec2 if ec2 != self.status['active_instance']
        end
      end

      ec2
    end

    def failover
      ha_type = @config.ha_type
      state = YAML.load_file(@config.state_file)
      active = state['active']
      passive = state['candidate']

      util = Awsutil.new(@config)

      if ha_type == 'eip'
        # Disassociate public ip
        util.disassociate_address(@config.elastic_ip)

        # Associate public ip to passive instance
        util.associate_address(@config.elastic_ip, passive)
      elsif ha_type == 'elb'
      else
        raise "Unsupported HA type: '#{ha_type}'."
      end
    end
  end
end
