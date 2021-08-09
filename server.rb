require 'rack'
require 'json'
require 'pry-nav'
require_relative './github'

class Server
  def call(env)
    return_body, return_status = nil, nil

    begin
      protect_main_branch(env) if create_repo_event?(env)
      return_body = "OK"
      return_status = 200
    rescue
      return_body = "There was a problem processing this event"
      return_status = 500
    ensure
      return [return_status, {}, [return_body]]
    end
  end

  private

  def request_body(env)
    return env["parsed_request_body"] if env["parsed_request_body"]

    body = env["rack.input"].read
    env["body"] = body
    body = "{}" if body.empty?
    body = body.gsub("\\n", "")
    body = JSON.parse(body)
    env["parsed_request_body"] = body
    body
  end

  def request_headers(env)
    return env["headers"] if env["headers"]

    headers = env.select do |k,v|
      k.start_with? 'HTTP_'
    end.transform_keys { |k| k.sub(/^HTTP_/, '') }
    headers.transform_keys { |k| k.upcase }
    env["headers"] = headers
    headers
  end

  def repo_name(env)
    request_body = env.dig("parsed_request_body", "repository", "full_name")
    env["parsed_request_body"].dig("repository", "full_name")
  end

  def protect_main_branch(env)
    ::GitHub.protect_repo(repo_name(env), "main", env["logger"])
  end

  def create_repo_event?(env)
    request_body = request_body(env)
    request_headers = request_headers(env)
    return false if request_body.nil? || request_headers.nil?

    request_body["action"] === "created" && request_headers["X_GITHUB_EVENT"] == "repository"
  end
end
