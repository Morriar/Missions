## Building

Run in console:

~~~bash
make
~~~

## Configuring

See the `app.ini` file to configure the popcorn app:

* `app.host`: app hostname
* `app.port`: app port
* `app.root_url`: used for redirect/call back from 3rd-party authentications.
  To use if behind a reverse proxy or if host is 0.0.0.0

## Running

Run in console:

~~~bash
make run
~~~

## Testing

Use `db_loader` to populate the database with test data.

~~~bash
make populate
~~~

## Docker

1. install docker. https://docs.docker.com/engine/installation/
2. install docker-compose. https://docs.docker.com/compose/install/
3. run `docker-compose up` in the root directory; (ctrl-C to close)
4. open http://localhost:3000

By default, a localhost server with shib authentication is used.
Specific configuration should be provided in `app.ini`.
Unless such a specific file, `app.docker.ini` is used.

See `Dockerfile`, `docker-compose.yml` and `app.docker.ini` for details.

## Contributing

The `Missions` team is happy to receive contributions and suggestions.
Give a look at the Github repo
[https://github.com/Morriar/Missions](https://github.com/Morriar/Missions).

### Code style

Mission enforces the following code style rules:

* All the Nit coding standards
* The `do` is on the same line as the function declaration
