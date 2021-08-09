require 'dotenv/load'
require 'logger'
require_relative './server'
require_relative './request_logger'

DEFAULT_PORT = 80

logger = ::Logger.new(STDERR) # FIXME - can't get STDOUT to work with ECS / cloudwatch out of the box
logger.level = ::Logger::INFO

app = ::Rack::Builder.new do
  use ::Rack::Reloader
  use ::Rack::CommonLogger, logger
  use ::RequestLogger, logger
  run ::Server.new
end.to_app

logger.info("Starting up...")
Rack::Server.start(app: app, Host: ENV["HOST"], Port: ENV["PORT"] || DEFAULT_PORT)
