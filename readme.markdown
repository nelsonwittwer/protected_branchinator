# Protected Branchinator

Web service that listens to GitHub organization webhook events.

When new repos are created,
this project will automatically protect the `main` branch through the
power of software.

## Running Instructions

### 1. Environment Variables

Protected Branchinator adheres to the
[twelve-factor](https://12factor.net/) tenet of storing configuration in
the environment. Environment variables will be required to be passed in
when running the server or the container running the server.

If running locally, create a .env file (which is ignored by git) with the following value:

#### .env
```
GITHUB_TOKEN=somewhere_over_the_token
```

#### Required Environment Variables

An environment variable of `GITHUB_TOKEN` is required to make the requests to protect branches.
NOTE - The GitHub client is dependent upon an environment variable `GITHUB_TOKEN`
being supplied.

https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token

#### Optional Environment Variables

`PORT` - To override the server default of `3030`


## 2. Running the server

### Running on the command line

`ruby main.rb` will get you up and running!

### Running in Docker

Protected Branchinator is designed to run in Docker. Ensure your
container properly attaches to the port that is exposed to run the
service. Unless it is overriden with the `PORT` environment variable,
the default is port `3030`.

## 3. Things to clean up

I focused my time on this project on getting a demo up as soon as
possible while maintaing a balance of reliability with testing the
pieces of this service along the way.

I wish I had more time to fix the things I already know I'd need to
change to make production ready, but balancing my available time for
this and the other parts of the challenge I figured I'd draw a line to
ship and give a roadmap of things I'd change if I could.

### a. Switch to Oauth

If I had ample time, I should really be using OAuth here but this solution was the fastest to verify everything was working as expected.
I decided to focus on shipping a first iteration that I could demo rather than having a perfectly implemented solution.

### b. Additional ENV variables

The defaults declared in GitHub::DEFAULT_PROTECT_BRANCH_OPTIONS
shouldn't be hard coded, but should take their values from ENV variables
that could be changed with a configuration change and not a software
change. Again, needing the draw the line to shipping somewhere I'd love
to configure that but I need to spend my time on a solid working demo
than a bullet proof production ready app.
