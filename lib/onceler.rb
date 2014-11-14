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

require_relative './onceler/cache'
require_relative './onceler/entry'
require_relative './onceler/server'
