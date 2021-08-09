require 'dotenv/load'
require "pry-nav"
require "logger"
require_relative "./github"
logger = ::Logger.new(STDERR) # FIXME - can't get STDOUT to work with ECS / cloudwatch out of the box
logger.level = ::Logger::INFO

GitHub.protect_repo("DevMixtape/testing123", "main", logger)
