source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "dotenv"
gem "octokit", "~> 4.0"
gem "rack"

group :development, :test do
  gem "pry-nav"
  gem "rspec"
end
