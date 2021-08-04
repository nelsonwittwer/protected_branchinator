require "spec_helper"
require_relative "../github"

describe GitHub do
  before do
    allow_any_instance_of(::Octokit::Client).to receive(:login)
    allow_any_instance_of(::Octokit::Client).to receive(:protect_branch)
  end

  let(:repo_name) { "nelsonwittwer/dat_repo_tho" }
  let(:branch_name) { "main" }
  let(:options) { ::GitHub::DEFAULT_PROTECT_BRANCH_OPTIONS }

  context "protect_repo" do
    context "when only specifying repo name" do
      it "protects the 'main' branch of the repo" do
        expect_any_instance_of(::Octokit::Client).to receive(:protect_branch).with(repo_name, branch_name, options)
        ::GitHub.protect_repo(repo_name, branch_name)
      end
    end

    context "when specifying a branch name" do
      let(:branch_name) { "dat_branch_tho" }

      it "protects the branch specified" do
        expect_any_instance_of(::Octokit::Client).to receive(:protect_branch).with(repo_name, branch_name, options)
        ::GitHub.protect_repo(repo_name, branch_name)
      end
    end

    context "when specifying options" do
      let(:options) {
        {
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
            "required_approving_review_count":2
          }
        }
      }

      it "protects branch with options specified" do
        expect_any_instance_of(::Octokit::Client).to receive(:protect_branch).with(repo_name, branch_name, options)
        ::GitHub.protect_repo(repo_name, branch_name, options)
      end
    end
  end
end
