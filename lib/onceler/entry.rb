module Onceler
  class Entry
    attr_reader :key, :content, :remote_host, :remote_ip, :filename, :created

    def initialize(content, remote_host, remote_ip, filename:nil, once: true, key: nil)
      @content = content
      @remote_host = remote_host
      @remote_ip = remote_ip
      @filename = filename
      @once = once
      @created = Time.now.to_i

      @key = key || Onceler::Cache.random_key
    end

    def attachment?
      !!filename
    end

    def once?
      !!@once
    end

    def created_by
      remote_host || remote_ip
    end

    # Make an absolute URL relative to the user-provided request_url.
    #
    # @param request_url [String]
    # @return [String]
    #
    def url(request_url, delete_link: false)
      uri = URI.parse(request_url)
      if @once || delete_link
        uri.path = "/once/#{key}/"
      else
        uri.path = "/clip/#{key}/"
      end
      uri.query = nil
      uri.fragment = nil

      unless ['http', 'https'].include?(uri.scheme)
        raise ArgumentError.new("Bad URI scheme #{uri.inspect}")
      end

      return uri.to_s
    end
  end
end
