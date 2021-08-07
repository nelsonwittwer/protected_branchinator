require 'dotenv/load'
require_relative './server'

DEFAULT_PORT = 80

app = ::Rack::Builder.new do
  use ::Rack::Reloader
  run ::Server.new
end.to_app

Rack::Server.start(app: app, Host: ENV["HOST"], Port: ENV["PORT"] || DEFAULT_PORT)
