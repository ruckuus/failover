require File.join(File.dirname(__FILE__), '../provider')

module Failover
  class Provider::Service < Provider
    def get_service_status(hostname, service_name)

    end

    def get_service_status_bulk(hostname, service_arr)

    end
  end
end
