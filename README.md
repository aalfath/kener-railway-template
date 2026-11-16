# Kener on Railway

This repo deploys [Kener](https://github.com/rajnandan1/kener), the open-source status page and uptime monitor, on [Railway](https://railway.com).

## What the template deploys

| Service | Source | Notes |
|---|---|---|
| Kener | this repo (`Dockerfile`) | Kener **v4.2.1**, official image `rajnandan1/kener:4.2.1` pinned by digest. Public, port 3000, health check `/healthcheck` |
| Postgres | Railway Postgres | All Kener data: monitors, incidents, users, settings and uploaded images |
| Redis | Railway Redis | Kener's job queues (BullMQ), cache and scheduler. Required by Kener v4 |

The repo adds only `railway-start.sh`. It sets `ORIGIN` from Railway's public domain if it's empty, and adds `family=0` to `REDIS_URL` so the Redis client can reach Redis over Railway's private network.

## Variables (Kener service)

| Variable | Default | Purpose |
|---|---|---|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Postgres connection |
| `REDIS_URL` | `${{Redis.REDIS_URL}}` | Redis connection |
| `KENER_SECRET_KEY` | `${{secret(32)}}` | Signs sessions and tokens. Generated per deploy |
| `ORIGIN` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL. Change it if you add a custom domain |
| `PORT` | `3000` | Port Kener listens on |

You don't need to enter anything at deploy time. Optional features are set later as extra variables on the Kener service, for example email through `RESEND_API_KEY` and `RESEND_SENDER_EMAIL`, or `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASSWORD`, `SMTP_SENDER` and `SMTP_SECURE` (see [Kener's docs](https://kener.ing/docs)).

## First setup

Open the public URL right after the deploy finishes. Kener asks for a name, email and password and makes that account the admin. There is no default password. Until you create that account, anyone who opens the URL can claim it, so do it first.

## Updates

The Kener service builds from this repo's `main` branch. When a new Kener version is pinned here, Railway shows you an "update available" notice in your project, and you choose when to apply it. Each version is listed in [CHANGELOG.md](CHANGELOG.md), with breaking changes first. Your data stays in Postgres across updates. Kener runs its database migrations on start.
