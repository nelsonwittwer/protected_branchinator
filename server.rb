require 'dotenv/load'
require 'rack'
require 'json'
require_relative './github'

class Server
  attr_reader :env, :body, :headers, :return_status, :return_body

  def call(env)
    @env = env
    @body = JSON.parse(env["body"])
    @headers = env["headers"]

    begin
      protect_main_branch if create_repo_event?
      @return_body = "OK"
      @return_status = 200
    rescue
      @return_body = "There was a problem processing this event"
      @return_status = 500
    ensure
      return [return_status, {}, return_body]
    end
  end

  private

  def protect_repo
    ::GitHub.protect_main_branch(body, 'main')

  end
  def create_repo_event?
    body["action"] === "created" && headers["X-GitHub-Event"] == "repository"
  end
end
