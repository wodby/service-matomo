# Matomo on Wodby

What Wodby sets up for Matomo on this service, in addition to the PHP service it is based on.

## Database settings

The service passes the linked database to Matomo under the names Matomo's installer reads: `MATOMO_DATABASE_HOST`, `MATOMO_DATABASE_USERNAME`, `MATOMO_DATABASE_PASSWORD` and `MATOMO_DATABASE_DBNAME`. The installer's database step is prefilled from them, and the password is taken from the variable when the masked field is left unchanged. Do not type other credentials there and do not put credentials in the repository.

These variables are read by the installer only. Once Matomo is installed, its connection settings are in `config/config.ini.php`. Matomo does not read the PHP service's `wodby.settings.php`.

## Build

The image is built from the Matomo codebase in the connected repository with this service's own Dockerfile: the code is copied to `/var/www/html`, Matomo's `tmp` directories are created, and `config`, `misc/user`, `tmp`, `plugins`, `matomo.js` and `piwik.js` are made writable by the web user. The build pipeline of the Matomo boilerplate runs `composer install` before the image is built.

## Data

This service declares no volume. What Matomo writes inside the container, including `config/config.ini.php` written by the installer, plugins installed from the interface and everything under `tmp`, is in the container's file system and is replaced by a new build or a restart. Reports and settings stored in the database are not affected.

## After deployment

After every deployment the service runs `php console core:update --yes`, and only when `config/config.ini.php` exists.

## Limits

- The service runs as a single instance; it is not scalable.
- It has no development workspace.

## Check the result

- Once Matomo is installed, `php console diagnostics:run` reports the state of the installation, including the database connection.
