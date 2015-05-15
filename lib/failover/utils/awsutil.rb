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

    def get_active_ec2_instance_by_elb(loadbalancer_name)
      resp = self.describe_loadbalancer(@loadbalancer_name)

      ids = nil
      resp.data.load_balancer_descriptions.each do |el|
        if el.instances.count > MAX_ACTIVE_INSTANCE
          return 'Unsupported'
        else
          return el.instances[0].instance_id if el.instances
        end
      end

      ids
    end

    def get_active_ec2_instance_by_eip(public_ip)
      resp = self.describe_address(public_ip)

      ids = nil
      ids = resp.data.addresses[0].instance_id if resp.data.addresses[0].instance_id

      ids
    end

    alias get_active_instance_by_eip get_active_ec2_instance_by_eip
    alias get_active_instance_by_elb get_active_ec2_instance_by_elb
  end
end
