require 'dotenv/load'
require "pry-nav"
require_relative "./github"

GitHub.protect_repo("DevMixtape/elastic_playground", "main")
