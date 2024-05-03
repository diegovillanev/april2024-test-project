# april2024-test-project

A generic environment implementing a Docker Compose file with 4 services plus some helper services.

## Instructions

### Requirements:
  * A freshly-made VM with Docker installed.
  * Execution permissions on the `install.sh` script (You should already have them).

To start the services, you need to execute the script as follows: `./install.sh`. The script will automatically detect which Docker Compose files and Dockerfiles it should execute depending on the user running them, and then create the dummy Laravel project, bring up the database, and make modifications to the project to establish the connection and retrieve a DB row.

The execution order of the script is as follows:
  1. Bring up the Laravel App through its 3 main services: Nginx, PHP, and MySQL, and 2 secondary services: Redis and Mailhog (Laravel dependencies)
  2. These services require their own dependent services, which are the tools needed to bring up the project: Composer, Artisan, and NPM
  3. Once the services are up, scaffold the Laravel project using the ephemeral Composer service
  4. Modify the project to connect to our MySQL database and to be able to retrieve a record.

The way the services are designed allows us to use Composer, Artisan, and NPM commands without having them installed locally. If necessary to use, they can be run ephemeraly using:

  * docker-compose run --rm composer ...
  * docker-compose run --rm npm ...
  * docker-compose run --rm artisan ...

If it is necessary to modify the scripts or files and have to bring up the project again, you only need to use:

`docker compose down && ./install.sh`