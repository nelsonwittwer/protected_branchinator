require "octokit"

class GitHub
  class << self

    ##
    # Protects specified branch for repo.
    #
    # @repo_name - Integer, String, Hash, Repository) — A GitHub repository.
    # @branch_name - String - defaults to 'main'
    # @options - Hash - :required_status_checks (Hash) — If not null, the following keys are required:
    #  :enforce_admins [boolean] Enforce required status checks for repository administrators.
    #  :strict [boolean] Require branches to be up to date before merging.
    #  :contexts [Array] The list of status checks to require in order to merge into this branch
    #  :restrictions (Hash) — If not null, the following keys are required: :users [Array] The list of user logins with push access
    #  :teams [Array] The list of team slugs with push access.
    #
    #  Teams and users restrictions are only available for organization-owned repositories.
    #
    # Protect Branch Method Docs:
    # http://octokit.github.io/octokit.rb/Octokit/Client/Repositories.html#protect_branch-instance_method
    #
    # See also:
    # https://developer.github.com/v3/repos/#enabling-and-disabling-branch-protection
    #
    def protect_repo(repo_name, branch_name = 'main', options = {})
      puts "Protecting #{branch_name} branch for #{repo_name}"
      client.protect_branch(repo_name, branch_name, options)
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
