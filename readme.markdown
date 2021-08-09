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
Without this token, branch settings will not be changed.

https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token

#### Optional Environment Variables

`PORT` - To override the server default of `80`
`HOST` - Host address for the server

## 2. Running the server

### Running on the command line

`ruby main.rb` will get you up and running!

### Running in Docker

Protected Branchinator is designed to run in Docker. Ensure your
container properly attaches to the port that is exposed to run the
service. Unless it is overriden with the `PORT` environment variable,
the default is port `80`.

### Deployment
0. Login to AWS CLI
You'll need to configure your [AWS
CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) to use your AWS API key.

1. Build new Docker image

```
docker build . -t protected_branchinator
```

2. Login to AWS ECR

```
aws ecr get-login-password --region us-east-1 | sudo docker login
--username AWS --password-stdin
AWSID.dkr.ecr.us-east-1.amazonaws.com`
```

3. Tag latest branch

```
  docker tag protected_branchinator:latest AWSID.dkr.ecr.us-east-1.amazonaws.com/protected_branchinator:latest
```

4. Trigger new deployment

```
 aws ecs update-service --cluster protected_branchinator --service protected_branchinator --force-new-deployment
```

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

### c. Run container as different user than root

ECS Fargate has an unfortunate limitation that they don't let you map
ports. If I run a container on port 3030 the host port has to also be
3030. Layering on to that complication, there are permissioning issues
      to running containers on protected ports (80) that were going to
take more time to solve.

In order to get this demo working, I removed my usual workflow of
running on large port and mapping to standard TCP port to just running
port 80 as root. This is gross and opens up a few security
vulnerabilities.


### d. Lock down GitHub event hook API

[Securing
webhooks](https://docs.github.com/en/developers/webhooks-and-events/webhooks/securing-your-webhooks)
is pretty stragith forward, but I wanted to limit my scope for this
initial proof-of-concept in favor of shipping.

### e. Add HTTPS application load balancer

Currently the GitHub organization event is configured to send events to
the public IP address of the container running this image. This makes
automatic deployments super tricky and also exposes GitHub events to HTTP
listeners which is a security risk.
