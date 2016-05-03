# Ruby image
FROM ruby

# Install bundler
RUN gem install bundler --no-ri --no-rdoc

# Make app folder
RUN mkdir venduitz/

# Set as workdir
WORKDIR venduitz/

# Add the full source
ADD . .

# Install!
RUN bundle install
