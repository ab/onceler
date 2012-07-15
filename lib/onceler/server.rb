module Onceler
  class Server < Sinatra::Base
    set :bind, Onceler::BIND
    set :port, Onceler::PORT
    disable :show_exceptions
    enable :logging, :dump_errors

    # to support global state, process only one request at a time
    # obviously this is not incredibly scalable
    enable :lock

    @@cache = Cache.new

    not_found do
      "I think we took a wrong turn! took a wrong turn turn ...\n"
    end

    get '/' do
      "This is onceler!\n"
    end

    get '/once/:key/' do |key|
      begin
        data = @@cache.get(key)
      rescue IndexError
        raise Sinatra::NotFound
      end

      "This key was created by #{data.ip_address} at #{Time.at(data.created)}\n"
    end

    post '/once/' do
      data = Entry.new(params.fetch('content'), request.ip, params['filename'])

      key = @@cache.add(data)

      url = Onceler.base_url + "/once/#{key}/"
      url + "\n"
    end

    post '/once/:key/get' do |key|
      begin
        data = @@cache.delete(key)
      rescue IndexError
        raise Sinatra::NotFound
      end

      if data.attachment?
        attachment data.filename
      end

      data.content
    end
  end
end
