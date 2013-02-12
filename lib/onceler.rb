require 'logger'
require 'yaml'

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'

module Onceler
  def self.root_folder
    File.join(File.dirname(__FILE__), '..')
  end
end

$:.unshift File.dirname(__FILE__)
require 'onceler/cache'
require 'onceler/entry'
require 'onceler/server'
