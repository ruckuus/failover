require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/failover')

require 'rubygems'
require 'bundler/setup'
require 'timeout'

failover = Failover.Init(File.join(File.expand_path(File.dirname(__FILE__)), '../config.yml'))
Failover.Start
Failover.Stop
