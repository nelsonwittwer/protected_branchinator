require "octokit"

class GitHub
  ##
  # Constants
  #
  DEFAULT_PROTECT_BRANCH_OPTIONS = {
    "required_status_checks" => {
      "enforcement_level" => "everyone",
      "contexts" => [
        "default"
      ]
    },
    "enforce_admins":true,
    "required_pull_request_reviews":{
      "dismissal_restrictions":{
        "users":["nelsonwittwer"],
      },
      "dismiss_stale_reviews":true,
      "require_code_owner_reviews":true,
      "required_approving_review_count":6
    }
  } # FIXME - Should make defaults configurable via ENV variables instead of hard coding

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
    # NOTE - The GitHub client is dependent upon an environment variable `GITHUB_TOKEN`
    # being supplied. If running locally, create a .env file with the following value:
    #
    # GITHUB_TOKEN=somewhere_over_the_token
    #
    # https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token
    #
    # FIXME - Should really be using OAuth here but this solution was the fastest to verify everything was working as expected.
    #
    def protect_repo(repo_name, branch_name = 'main', options = DEFAULT_PROTECT_BRANCH_OPTIONS)
      puts "Protecting #{branch_name} branch for #{repo_name}"
      response = client.protect_branch(repo_name, branch_name, options)
      puts response
    end

    private

    def client
      @client ||= ::Octokit::Client.new(:access_token => ENV["GITHUB_TOKEN"])
    end
  end
end
