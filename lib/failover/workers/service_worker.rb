require_relative '../utils/health'

module Failover
  class Worker::Service < Worker
    OK = 0
    NOK = 8
    ALARM = 256

    def do_parse_status(service, status)
      if status.kind_of?(TrueClass)
        return OK
      elsif status.kind_of?(FalseClass)
        return @score[service]
      else
        return ALARM
      end
    end

    def do_check_services_status(zone, vm_hash)
      instance_id = vm_hash['instance_id']
      hostname = vm_hash['hostname']
      private_ip = vm_hash['private_ip']

      services = @config.get_services(zone)
      allstat = provider.get_service_status(hostname, services)

      @status[instance_id] = allstat
    end

    def check_instance
      @config.instances.each do |groups|
        groups.each do |zone, vms|
          vms.each do |vm|
            self.do_check_services_status(zone, vm)
          end
        end
      end

      @status
    end

    def start
      status = check_instance

      status.each do |iid, srvs_status|
        tmp = Hash.new
        srvs_status.each do |name, text|
          tmp[name] = do_parse_status(name, text)
        end
        Failover::Health.set(iid, tmp)
      end
    end

    def stop
      super
    end
  end
end
