require 'securerandom'

module Onceler
  class Entry
    attr_reader :content, :remote_host, :remote_ip, :filename, :created

    def initialize(content, remote_host, remote_ip, filename=nil)
      @content = content
      @remote_host = remote_host
      @remote_ip = remote_ip
      @filename = filename
      @created = Time.now.to_i
    end

    def attachment?
      not @filename.nil?
    end
  end
end
