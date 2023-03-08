# Fieldsets PostgreSQL Docker Server

This repository will create Fieldsets's PostgreSQL RDBMS data architecture within a docker container. This allows us to deploy Fieldsets's standard data structures to Amazon EC2 instances which on average cost 25% less than Amazon RDS instances.

Currently this repository only recreates empty data structures found in the [SQL sub-directory](./initdb/sql/) of this repository. Integration of Fieldsets Phi is a work in progress.

While this repository can serve as a boiler plate for any relevant projects, it is better to be used within a larger compose file to create compartmentalized projects. See how we combine this repository with [fieldsets-local](https://github.com/Fieldsets/fieldsets-local) to automate data migrations and creation of foreign data wrappers in our [Fieldsets Pipeline Repository](https://github.com/Fieldsets/fieldsets-pipeline)

## Installation & Getting started

*TL;DR*

```
git clone --recurse-submodules https://github.com/fieldsets/docker-postgres.git
cd docker-postgres
cp ./env.example ./.env (optional for customization)
docker-compose up -d --build
```

## System Requirements.
Before we begin, you must have the following installed locally on your machine. Follow the links below for directions on how to get setup on your current environment.

- [docker-compose](https://docs.docker.com/compose/install/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Mac OS
Using the terminal execute the following steps
- Install Xcode
    - `xcode-select --install`
- Install homebrew
    - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
- Disable homebrew analytics
    - `brew analytics off`
- Install git
    - `brew install git`
- Install docker-compose
    - `brew install docker`
- Run caffeinate to prevent sleep on first run
    - `caffeinate`

### Linux (Debian based)
- Install git
    - `sudo apt install docker`
- Install git
    - `sudo apt install git`

## Install Steps
Once you have installed git and docker, the first step is to clone the `docker-postgres` repository and all of it's submodules into your local environment. Since we have no submodles to install, we can omit the `--recurse-submodules` parameters, but often projects have their own repositories. Installing them as a submodule is an option to decouple any applications, scrapers, metrics, scores, etc. from our established pipeline.

```
git clone --recurse-submodules https://github.com/fieldsets/docker-postgres.git
cd docker-postgres
cp ./env.example ./.env
```

 You can optionally make a copy of the [example env file](./env.example) if you want to change any configuration parameters (like postgres version or the path of your private key). While this is unnecessary as the project will run with the default values set in the `docker-compose.yml` file, it is good to minmally set the following variables in your local dotenv file.

- `LOCAL_UID`: use the command in your terminal `id -u`. Setting the container to have the same user id will allow you to write directly to container volumes without issue.
- `LOCAL_GID`: use the command in your terminal `id -g`.

## Running the container
Now lets get the environment running!

Once docker compose is installed and you have cloned this repository as instructed above, you can get the entire environment up and running with the following command:

```docker-compose up -d```

That's it! You should be up and running. The first docker build may take a while as it imports containers remotely and can vary depending on network speed and your local environment hardware. If you'd like to view what is happening on the install you can track the output logs of the container that does all the heavy lifting with the following command:

```docker-compose logs -f fieldsets-postgres```

When you are done using the environment you can halt the environment using the command:

```docker-compose stop```

## Configuration
This repository can run without any modifications to the configuration. That said, this repository makes configuration of PostgreSQL easy by editing the [postgresql.conf file](./postgresql.conf). Some performance notes can be found below if you chose to do so.
  - `effective_cache_size` should be set to 50% of instance memory
  - `shared_buffer` should be set to 25% of instance memory
  - `maintenance_work_mem` should be increased when recreating indexes
  - Ensure WAL is on separate volume

## Extending this Repository
You can extend this repository by creating your own data structures. You can add in the creation of any core data structures using the [initdb directory](./initdb/). Any files found in the top level of this directory with the `.sh` or `.sql` extension will be run on the first build, but not again after that. Also, any files with a `.sql` extension found in any of the [sql subdirectories](./initdb/sql/) will be run at the appropriate time during the initial start up. 

*NOTE:* Any `.sql` files found in the top level `./initdb/sql/` directory will not be run. They must be place in one of the subdirectories to be executed on first build.