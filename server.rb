require 'rack'
require 'json'
require 'pry-nav'
require_relative './github'

class Server
  attr_reader :env, :body, :headers, :return_status, :return_body

  def call(env)
    @env = env

    begin
      protect_main_branch if create_repo_event?
      @return_body = "OK"
      @return_status = 200
    rescue
      @return_body = "There was a problem processing this event"
      @return_status = 500
    ensure
      return [return_status, {}, [return_body]]
    end
  end

  private

  def body
    @body ||= begin
      return unless env["rack.input"].instance_of?(StringIO)
      body = env["rack.input"].read
      body == "" ? {} : JSON.parse(body)
    end
  end

  def headers
    @headers ||= begin
      env.select do |k,v|
        k.start_with? 'HTTP_'
      end.transform_keys { |k| k.sub(/^HTTP_/, '') }
    end
  end

  def repo_name
    body.dig("repository", "full_name")
  end

  def protect_main_branch
    ::GitHub.protect_repo(repo_name, "main")
  end

  def create_repo_event?
    return false if body.nil? || headers.nil?

    body["action"] === "created" && headers["X-GitHub-Event"] == "repository"
  end
end
