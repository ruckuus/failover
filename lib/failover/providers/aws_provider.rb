require_relative 'cloud_provider'
require_relative '../utils/awsutil'

module Failover
  class Provider::Cloud::Aws < Provider::Cloud

    def get_active_instance
      util = Awsutil.new(@config)
      # Get HA Setup (EIP or ELB)
      ha_type = @config.get_ha_type
      res = nil

      if ha_type == 'eip'
        res = util.get_active_instance_by_eip(public_ip)
      elsif ha_type == 'elb'
        res = util.get_active_instance_by_elb(elb_name)
      else
        raise "HA Type #{ha_type} is not supported."
      end

      res
    end

  end
end
