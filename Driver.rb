require 'sinatra'
require_relative 'KeyServer'

server = KeyServer.new

get '/key_gen' do
  if key = server.key_gen
    return "Key Generated"
  end
  "Key Generation unsuccessful, please try again!"
end

get '/get_key' do
  if key = server.get_key
    return key
  end
  halt 404, "No Available Key"
end

get '/keep_alive/:key' do
  if server.keep_alive(params['key'])
    return "Key kept alive for the next 5 minutes"
  end
  halt 404, "No Available Key or Key Expired!"
end

get '/unblock/:key' do
  if server.unblock(params[:key])
    return "Key unblocked"
  else
    halt 404, "No Available Key"
  end
end

get '/delete/:key' do
  if server.delete(params[:key])
    return "Key deleted"
  else
    halt 404, "No Such Key!"
  end
end
