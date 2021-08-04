class GitHub
  class << self
    def protect_repo(body)
      puts "Protecting main branch for new repo"
    end

    private

    def client
      @client ||= ::Octokit::Client.new(
        :login    => ENV["GITHUB_USERNAME"],
        :password => ENV["GITUB_PASSWORD"]
      )
    end
  end
end
