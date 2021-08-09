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
    context "when no branches on repo" do
      before do
        allow_any_instance_of(::Octokit::Client).to receive(:branches).and_return([])
      end

      it "does not protect anything" do
        expect_any_instance_of(::Octokit::Client).not_to receive(:protect_branch)
        ::GitHub.protect_repo(repo_name, branch_name)
      end
    end

    context "when branches exist" do
      before do
        allow_any_instance_of(::Octokit::Client).to receive(:branches).and_return([{}])
      end

      context "when only specifying repo name" do
        it "protects the 'main' branch of the repo" do
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

  context "create_issue" do
    let(:title) { "FYI - Automatically Protected main branch" }
    let(:sender) { "nelsonwittwer" }
    let(:body) { "@#{sender} - We have automatically protected the main branch of this new repository." }

    it "creates an issue with the expected arguments" do
      expect_any_instance_of(::Octokit::Client).to receive(:create_issue).with(repo_name, title, body, {})
      ::GitHub.create_issue(repo_name, title, body)
    end
  end
end
