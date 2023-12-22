# frozen_string_literal: true

require 'uri'
require 'rack/ssl-enforcer'
require 'resolv'

module Onceler
  class Server < Sinatra::Base
    set :bind, '127.0.0.1'
    set :port, 6623

    enable :logging, :dump_errors

    set :root, Onceler.root_folder

    # force HTTPS in production
    use Rack::SslEnforcer, :only_environments => ['production']

    # to support global state, process only one request at a time
    # obviously this is not incredibly scalable
    enable :lock

    @@cache = Cache.new

    not_found do
      @title = 'Onceler - Not Found'
      erb :not_found, layout: :layout
    end

    error do
      @title = 'Onceler - Error'
      erb :error, layout: :layout
    end

    get '/' do
      @title = 'Onceler'
      erb :root, layout: :layout
    end

    get '/healthcheck' do
      "OK\n"
    end

    get '/once/:key/' do |key|
      begin
        @entry = @@cache.get(key)
      rescue IndexError
        raise Sinatra::NotFound
      end

      @title = 'Onceler Secret'
      erb :info, layout: :layout
    end

    # you can view content of multi-use keys with GET request
    get '/clip/:key/' do |key|
      begin
        entry = @@cache.get(key)
      rescue IndexError
        raise Sinatra::NotFound
      end

      # Invalid to try to access a single-use key as multi-use.
      if entry.once?
        raise Sinatra::NotFound
      end

      if entry.attachment?
        attachment entry.filename
        entry.content
      else
        @entry = entry
        @delete_link = entry.url(request.url, delete_link: true)
        @title = 'Onceler Secret'
        erb :fetch, layout: :layout
      end
    end

    get '/once/' do
      redirect '/'
    end

    post '/once/' do
      if params['filename'] && params['filename'].length > 0
        filename = params['filename']
      else
        filename = nil
      end
      content = params.fetch('content')

      case params.fetch('action')
      when 'once'
        once = true
      when 'multi'
        once = false
      else
        raise ArgumentError.new("Invalid action: " + params['action'].inspect)
      end

      key = params.fetch('key', nil)

      request_ip = get_request_ip

      begin
        request_host = Resolv.getname(request_ip)
      rescue Resolv::ResolvError => err
        puts 'Failed to resolve host: ' + err.inspect
        request_host = nil
      end

      entry = Entry.new(content, request_host, request_ip, filename:filename,
                        once: once, key: key)
      @@cache.add_entry(entry)

      # make an absolute URL relative to the user-provided URL
      @secret_url = entry.url(request.url)

      @title = 'Onceler Link'
      erb :link, layout: :layout
    end

    post '/once/:key/' do |key|
      begin
        entry = @@cache.delete(key)
      rescue IndexError
        raise Sinatra::NotFound
      end

      if entry.attachment?
        attachment entry.filename
        entry.content
      else
        @entry = entry
        @deleted = true
        @title = 'Onceler Secret'
        erb :fetch, layout: :layout
      end
    end

    helpers do
      def escape(text)
        Rack::Utils.escape_html(text)
      end

      def get_request_ip
        if ENV['FLY_APP_NAME']
          # running in fly.io, need to get request IP from custom header
          request.env.fetch('HTTP_FLY_CLIENT_IP')
        else
          request.ip
        end
      end
    end
  end
end
