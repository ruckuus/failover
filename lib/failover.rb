require "failover/version"
require "failover/config"
require "failover/worker"
require 'failover/workers/cloud_worker'
require 'failover/workers/service_worker'
require "failover/provider"
require 'failover/providers/aws_provider'
require 'failover/providers/salt_provider'
require 'failover/providers/cloud_provider'
require 'failover/providers/service_provider'

module Failover
  def self.Init(config_file)
    @@status = 0
    @@health = Hash.new
    begin
      config = Config.new(config_file)

      # Setup Cloud Provider
      cloud = nil
      service = nil

      if config.cloud_provider == 'aws'
        cloud = Failover::Provider::Cloud::Aws.new(config)
      else
        raise 'Currently only supports AWS Cloud.'
      end

      if config.service_provider == 'salt'
        service = Failover::Provider::Service::Salt.new(config)
      else
        raise 'Currently only supports Salt.'
      end

      # Setup Worker
      @@cloud_worker = Failover::Worker::Cloud.new(cloud)

      # Setup Service Provider
      @@service_worker = Failover::Worker::Service.new(service)
    rescue Exception => e
      @@status = 1
      raise e
    end
  end

  def self.status
    @@status
  end

  def self.Start
    if self.status == 1
      raise 'Something wrong during init.'
    end

    @@cloud_worker.start
    @@service_worker.start
  end

  def self.Stop
    if self.status == 1
      raise 'Something wrong during Start'
    end

    @@service_worker.stop
  end

  def self.Decide

  end
end
