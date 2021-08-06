require "spec_helper"
require_relative "../server"

describe Server do
	let(:repo_create_payload) { File.read(File.join('spec', 'events', 'repo_created_event.json')) }
	let(:repo_publicized_event) { File.read(File.join('spec', 'events', 'repo_publicized_event.json')) }
	let(:milestone_created_event) { File.read(File.join('spec', 'events', 'milestone_created_event.json')) }
  let(:app) { Server.new }
  let(:env) { { "request_method" => "POST", "path_info" => "/github_events", "rack.input" => StringIO.new(body)}.merge(headers) }
  let(:response) { app.call(env) }
  let(:response_status) { response[0] }
  let(:headers) {
    {
      "HTTP_Host" => "localhost:4567",
      "HTTP_X-GitHub-Delivery" => "72d3162e-cc78-11e3-81ab-4c9367dc0958",
      "HTTP_X-Hub-Signature" => "sha1=7d38cdd689735b008b3c702edd92eea23791c5f6",
      "HTTP_X-Hub-Signature-256" => "sha256=d57c68ca6f92289e6987922ff26938930f6e66a2d161ef06abdf1859230aa23c",
      "HTTP_User-Agent" => "GitHub-Hookshot/044aadd",
      "Content-Type" => "application/json",
      "Content-Length" => 6615,
      "HTTP_X-GitHub-Event" => event
    }
  }

  before do
    allow(::GitHub).to receive(:protect_repo)
  end

  context "POST /github_events" do
    context "when empty request" do
      let(:env) { { "request_method" => "GET", "rack.input" => nil, "headers" => nil } }

      it "returns an ok status" do
        expect(response_status).to eq(200)
      end
    end

    context "when repo event" do
      let(:event) { "repository" }

      context "when action is create" do
        let(:body) { repo_create_payload }
        let(:repo_name) { JSON.parse(body)["repository"]["full_name"] }

        it "protects the main branch" do
          expect(::GitHub).to receive(:protect_repo).with(repo_name, "main")
          response
        end

        it "returns an ok status" do
          expect(response_status).to eq(200)
        end
      end

      context "when action is publish" do
        let(:body) { repo_publicized_event }

        it "does not modify the protected branch settings" do
          expect(::GitHub).not_to receive(:protect_repo)
          response
        end

        it "returns an ok status" do
          expect(response_status).to eq(200)
        end
      end
    end

    context "when milestone created" do
      let(:body) { milestone_created_event }
      let(:event) { "milestone" }

      it "does not modify the protected branch settings" do
        expect(::GitHub).not_to receive(:protect_repo)
        response
      end

      it "returns an ok status" do
        expect(response_status).to eq(200)
      end
    end
  end
end
