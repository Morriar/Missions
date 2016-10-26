FROM nitlang/nit

# Needed for nitcorn and to build mongo-c-driver
RUN apt-get update && apt-get install -y libevent-dev libssl-dev libsasl2-dev libcurl4-openssl-dev file

# Install mongo-c-driver manually since it is not available in Debian/jessie
RUN curl -L https://github.com/mongodb/mongo-c-driver/releases/download/1.4.0/mongo-c-driver-1.4.0.tar.gz -o mongo-c-driver-1.4.0.tar.gz \
	&& tar xzf mongo-c-driver-1.4.0.tar.gz \
	&& cd mongo-c-driver-1.4.0 \
	&& ./configure \
	&& make \
	&& make install \
	&& ldconfig

# Copy and compile the code
WORKDIR /missions
COPY . /missions/
RUN make pep8term && make

# Expose the web application
EXPOSE 3000

# Configuration is either:
# * A specific user-defined `app.ini` file, if any.
# * Or else, the provided `app.docker.ini` (versionned)
RUN test -f app.ini || cp app.docker.ini app.ini

# Populate and run
# TODO: stop populating
CMD make populate && make run
