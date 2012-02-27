require 'fileutils'
require 'net/https'
require 'yaml'
require 'time'
require 'logger'

require 'rubygems'
require 'nokogiri'

require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'feed'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'xml'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'http_error'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'poller'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'mingle_basic_auth_access'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'mingle_oauth_access'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'processors'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'project_custom_properties'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'entry_cache'))
require File.expand_path(File.join(File.dirname(__FILE__), 'mingle_events', 'project_event_fetcher'))

module MingleEvents
  
  attr_accessor :log
  module_function :log, :log=
  self.log = Logger.new(STDOUT)
  self.log.level = Logger::INFO


  URIParser = URI.const_defined?(:Parser) ? URI::Parser.new : URI
end
