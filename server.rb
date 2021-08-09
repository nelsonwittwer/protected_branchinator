require 'rack'
require 'json'
require 'pry-nav'
require_relative './github'

class Server
  def call(env)
    return_body, return_status = nil, nil

    begin
      protect_new_branch(env) if new_master_branch_created?(env)
      protect_new_branch(env) if create_repo_event?(env)
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

  def create_repo_event?(env)
    request_body = request_body(env)
    request_headers = request_headers(env)
    return false if request_body.nil? || request_headers.nil?

    request_body["action"] === "created" && request_headers["X_GITHUB_EVENT"] == "repository"
  end

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

  def protect_new_branch(env)
    ::GitHub.protect_repo(repo_name(env), "main", env["logger"])
    notify_of_branch_protection(env)
  end

  def new_master_branch_created?(env)
    request_body = request_body(env)
    return false if request_body.nil?
    return false if request_body["ref"].nil?
    return false if request_body["ref_type"] != "branch"

    request_body.dig("ref") == request_body.dig("master_branch")
  end

  def notify_of_branch_protection(env)
    event_sender = env.dig("parsed_request_body", "sender", "login")
    title = "FYI - Automatically Protected main branch"
    issue_body = "@#{event_sender} - We have automatically protected the main branch of this new repository."

    ::GitHub.create_issue(repo_name(env), title, issue_body)
  end
end
