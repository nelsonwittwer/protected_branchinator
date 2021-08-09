require 'pry-nav'
class RequestLogger
  attr_reader :app, :logger

  def initialize(app, logger = nil)
    @app, @logger = app, logger
    @logger ||= env[RACK_ERRORS]
  end

  def call(env)
    env["logger"] = logger
    status, headers, body = app.call(env)
    log(env.to_json)
    [status, headers, body]
  end

  private

  def log(msg)
    # Standard library logger doesn't support write but it supports << which actually
    # calls to write on the log device without formatting
    if logger.respond_to?(:write)
      logger.write(msg)
    else
      logger << msg
    end
  end
end
