FROM ruby:2.7
WORKDIR /srv/protected_branchinator
# Copy across dependencies and install them
COPY Gemfile Gemfile.lock /srv/protected_branchinator/
RUN bundle install
ADD . /srv/protected_branchinator

# Expose web server port
EXPOSE 80

CMD ["bundle", "exec", "ruby", "/srv/protected_branchinator/main.rb"]
