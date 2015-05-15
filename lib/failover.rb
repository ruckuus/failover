require "failover/version"
require "failover/config"
require "failover/worker"
require "failover/provider"
require 'failover/providers/aws_provider'
require 'failover/providers/cloud_provider'
require 'failover/providers/frontend_provider'
require 'failover/providers/service_provider'

module Failover
  def Failover::Init(config_file)
    config = Config.new(config_file)

    # Setup Cloud Provider
    # Setup Service Provider
    # Setup Worker

    cloud = nil
    service = nil

    if config.cloud_provider == 'aws'
      cloud = Failover::Provider::Cloud::Aws.new(config)
    end

    service = Failover::Provider::Service.new(config)

    @@cloud_worker = Failover::Worker.new(cloud)
    @@service_worker = Failover::Worker.new(service)
  end

  def Failover::Start
    @@cloud_worker.start
    @@service_worker.start
  end

  def Failover::Decide

  end
end
