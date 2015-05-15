module Failover
  class Awsutil
    def initialize(config)
      @elb = Aws::ElasticLoadBalancing::Client.new(
        region: config.get_region,
        access_key_id: config.get_access_key_id,
        secret_access_key: config.get_secret_access_key,
      )

      @ec2 = Aws::EC2::Client.new(
        region: config.get_region,
        access_key_id: config.get_access_key_id,
        secret_access_key: config.get_secret_access_key,
      )
    end

    def describe_address(public_ip)
      ips = nil
      if public_ip.kind_of?(Array)
        ips = public_ip
      else
        ips = [public_ip]
      end

      resp = @ec2.describe_addresses(
        public_ips: ips,
      )

      resp
    end

    def disassociate_address(public_ip)
      resp = @ec2.disassociate_address(
        public_ip: public_ip,
      )

      resp
    end

    def associate_address(public_ip, instance_id)
      resp = @ec2.associate_address(
        instance_id: instance_id,
        public_ip: public_ip,
        allow_reassociation: true,
      )

      resp
    end

    def describe_loadbalancer(elb_name)
      return nil if elb_name.nil?

      elbs = nil
      if elb_name.kind_of?(Array)
        elbs = elb_name
      else
        elbs = [elb_name]
      end

      resp = @elb.describe_load_balancers(
        load_balancer_names: elbs,
        page_size: 1,
      )

      resp
    end

    def register_instance(elb_name, instance_id)
      return nil if elb_name == nil or instance_id == nil

      resp = elb.register_instances_with_load_balancer(
        load_balancer_name: elb_name,
        instances: [
          {
            instance_id: instance_id
          },
        ]
      )

      resp
    end

    def deregister_instance(elb_name, instance_id)
      return nil if elb_name == nil or instance_id == nil

      resp = elb.register_instances_with_load_balancer(
        load_balancer_name: elb_name,
        instances: [
          {
            instance_id: instance_id
          },
        ]
      )

      resp
    end

    alias get_active_instance_by_eip describe_address
    alias get_active_instance_by_elb describe_loadbalancer
  end

end
