## Building

Run in console:

~~~bash
make
~~~

## Configuring

See the `app.ini` file to configure the popcorn app:

* `app.host`: app hostname
* `app.port`: app port

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

See `Dockerfile` and `docker-compose.yml` for detail
