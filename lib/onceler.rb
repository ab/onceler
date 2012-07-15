require 'logger'
require 'yaml'

require 'rubygems'
require 'sinatra/base'

module Onceler
  def self.base_url
    "https://foo"
  end

  BIND = '127.0.0.1'
  PORT = 6623
end

$:.unshift File.dirname(__FILE__)
require 'onceler/cache'
require 'onceler/entry'
require 'onceler/server'
