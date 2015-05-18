require_relative 'cloud_provider'
require_relative '../utils/awsutil'

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
  end
end
