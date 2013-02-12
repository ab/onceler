require 'uri'

module Onceler
  class Server < Sinatra::Base
    set :bind, Onceler::BIND
    set :port, Onceler::PORT
    disable :show_exceptions
    enable :logging, :dump_errors

    set :root, Onceler.root_folder

    # to support global state, process only one request at a time
    # obviously this is not incredibly scalable
    enable :lock

    @@cache = Cache.new

    not_found do
      erb :not_found
    end

    get '/' do
      erb :root
    end

    get '/once/:key/' do |key|
      begin
        @data = @@cache.get(key)
      rescue IndexError
        raise Sinatra::NotFound
      end

      erb :info
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
      data = Entry.new(content, request.host, request.ip, filename)

      key = @@cache.add(data)

      # make an absolute URL relative to the user-provided URL
      uri = URI.parse(request.url)
      uri.path = "/once/#{key}/"
      uri.query = nil
      uri.fragment = nil
      @secret_url = uri.to_s

      unless ['http', 'https'].include?(uri.scheme)
        halt 400, 'ERROR: Cowardly refusing to make URI of type ' + uri.scheme
      end

      @@cache.add(data)

      erb :link
    end

    post '/once/:key/get' do |key|
      begin
        data = @@cache.delete(key)
      rescue IndexError
        raise Sinatra::NotFound
      end

      if data.attachment?
        attachment data.filename
        data.content
      else
        @data = data
        erb :fetch
      end
    end
  end
end
