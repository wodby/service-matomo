# Matomo service for Kubernetes on Wodby

Run Matomo web analytics on Kubernetes with Wodby.

This repository defines the Wodby service manifests and operational
configuration for Matomo.

- [Browse Wodby services](https://wodby.com/services)
- [Wodby service documentation](https://wodby.com/docs/2.0/services/)
- [Service manifest reference](https://wodby.com/docs/2.0/services/template/)

## Wodby stacks using this service

- [Matomo application stack](https://github.com/wodby/stack-matomo)

## Service overview

| Property | Manifest configuration |
| --- | --- |
| Service name | `matomo` |
| Type | Application service |
| Image | [`wodby/matomo`](https://github.com/wodby/matomo) `-apache` variant: Matomo, Apache and PHP-FPM, prebuilt |
| Versions | `5` |
| Endpoint | HTTP on port 80 |
| Service links | Database (MariaDB or MySQL), required; Files storage, required; SMTP server |
| Settings | Admin username, Admin password (required), Admin email (required), Website URL |
| Volumes | `files`, shared |
| Cron | `archive`, hourly |
| Application build | None: the service runs the prebuilt image |
| Operations | 1 action |

## Upgrading from 2.x

Versions 2.x built Matomo from a repository with a separate Nginx service. Version 3 runs the prebuilt image, keeps
Matomo's settings on a files volume and installs Matomo itself. Apps on 2.x stay on it, because a new major is never
applied automatically; moving an app to version 3 means creating a new app from the Matomo stack.

## Use this service

Use this service through [Matomo application stack](https://github.com/wodby/stack-matomo), or reference `matomo` from a
custom Wodby stack.

A service is a reusable component and does not deploy by itself. The stack
defines its links, settings, versions, resources, and relationship to the rest
of the application.

## Maintain a custom version

1. Fork this repository.
2. Edit the service manifest and referenced files.
3. Import the repository as a [Git-backed service](https://wodby.com/docs/2.0/services/create/#create-a-git-backed-service).
4. Reference the service from a stack manifest.

Keep service, workload, container, endpoint, link, volume, config, and
derivative names stable unless dependent stacks and app-level overrides are
updated at the same time.

Validate the manifests with:

```bash
wodby service validate-manifest service.yml --org <org-id>
```

See the [service manifest reference](https://wodby.com/docs/2.0/services/template/) and the [managed services index](https://github.com/wodby/services).
