# Matomo on Wodby

What Wodby sets up for Matomo on this service.

## Image

The service runs the prebuilt [wodby/matomo](https://github.com/wodby/matomo) Apache image: Matomo's release, verified
against its signature, on the Apache variant of wodby/php. Apache serves Matomo and passes PHP to PHP-FPM in the same
container, on port 80. There is no build and no Git repository; a new image revision of the selected Matomo major
brings Matomo's updates.

Plugins can be installed from Matomo's Marketplace. They are kept on the files volume, so every replica loads them and
they survive new images.

## Settings

Matomo writes its settings to `config/config.ini.php`. The image also writes `config/common.config.ini.php` on every
start, a layer Matomo reads but never writes:

- **Database.** `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME` and `DB_PASSWORD` from the `db` link, with the `matomo_`
  table prefix. The password is never copied into `config.ini.php`.
- **Salt.** `MATOMO_SALT`, generated once for the app. It is mixed into every password hash, API token and session:
  never change it.
- **Trusted hosts.** Every route of the app (`WODBY_HOSTS`).
- **Proxy.** HTTPS when the main route uses it, and the client address from `X-Forwarded-For`, because TLS ends before
  the request reaches the container.
- **Installer and updates.** The web installer and Matomo's own updater are off; the image brings the code.
- **Archiving.** Reports are archived by the hourly cron job, not when someone views them.

## Data

The `files` volume is mounted at `/mnt/files` and shared by every replica and the cron job through the linked storage
service. It holds `config.ini.php` (plugin activation and every setting saved in Matomo), custom logos (`misc/user`)
and Marketplace plugins. Matomo's cache stays in each container. The database holds reports, visits and users;
sessions are kept in the database.

## Installation and updates

After every deployment the **Install or update Matomo** action runs `matomo-update`:

- **First deployment:** it installs Matomo into the empty database, as the web installer would. The superuser comes from
  the service's settings: `admin-username` (default `admin`, `MATOMO_ADMIN_USERNAME`), `admin-password` (required,
  secret, `MATOMO_ADMIN_PASSWORD`) and `admin-email` (required, `MATOMO_ADMIN_EMAIL`). When `website-url`
  (`MATOMO_SITE_URL`) is set, the first website is added with the app's title as its name; otherwise Matomo asks for a
  website at the first sign-in.
- Without an admin password or email, the action fails and installs nothing.
- The installation never runs over existing tables: if the database has tables but `config.ini.php` is missing, the
  action fails instead.
- **Later deployments:** it runs `php console core:update --yes`.
- Changing the admin settings after the first deployment does not change the account; change it in Matomo.

## Archiving

The `archive` cron job runs `php console core:archive` at five past every hour. It also sends scheduled email reports
and runs Matomo's other scheduled tasks.

## Limits

- Matomo 5 on PHP 8.4, with MariaDB or MySQL.
- Plugins that change the tracker script `matomo.js` rebuild it in the container where they run; restart the service
  after activating one so every replica serves the new script.
- No development workspace.

## Check the result

- **Administration > System > Diagnostics** shows Matomo's own checks.
- `php console diagnostics:run` reports the state of the installation.
- The deployment's post-deploy log shows the install or update output, and the cron job's log the archiving.
