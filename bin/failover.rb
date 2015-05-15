require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/failover')

require 'rubygems'
require 'bundler/setup'
require 'timeout'

failover = Failover.new(File.join(File.expand_path(File.dirname(__FILE__)), '../config.yml'))
status = failover.worker.do_poll

