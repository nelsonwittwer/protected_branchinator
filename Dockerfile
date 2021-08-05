FROM ruby:2.7
# Create and switch to a user called app
RUN useradd -ms /bin/bash app
WORKDIR /home/app
# Copy across dependencies and install them
COPY Gemfile Gemfile.lock /home/app/
RUN bundle install
ADD . /home/app
RUN chown -R app:app /home/app
USER app

# Expose web server port
EXPOSE 3030

CMD ["ruby", "/home/app/main.rb"]
