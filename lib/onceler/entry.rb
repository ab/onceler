require 'securerandom'

module Onceler
  class Entry
    attr_reader :content, :ip_address, :filename, :created

    def initialize(content, ip_address, filename=nil)
      @content = content
      @ip_address = ip_address
      @filename = filename
      @created = Time.now.to_i
    end

    def attachment?
      not @filename.nil?
    end
  end
end
