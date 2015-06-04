require_relative '../base/service_provider'
require 'saltrb/service'

module Failover
  class Provider::Service::Salt < Provider::Service

    def get_service_status(hostname, services)
      stats = Hash.new

      if services.kind_of?(Array)
        services.each do |name|
          stats[name] = Saltrb::Service.status(hostname, name)
        end
      else
        stats[services] = Saltrb::Service.status(hostname, services)
      end

      stats
    end
  end
end
