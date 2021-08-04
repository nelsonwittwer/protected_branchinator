FROM ruby:2.7
# Create and switch to a user called app
RUN useradd -ms /bin/bash app
WORKDIR /home/app
# Copy across dependencies and install them
ONBUILD COPY Gemfile Gemfile.lock /home/app/
ONBUILD RUN bundle install
ONBUILD ADD . /home/app
ONBUILD RUN chown -R app:app /home/app
ONBUILD USER app

# Expose web server port
EXPOSE 3030

CMD ["ruby","main.rb"]
