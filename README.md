# Reponet.work

A federated code hosting platform for [Jujutsu (jj)](https://jj-vcs.github.io/jj/) VCS built with Elixir and Phoenix.

## Why Reponet?

Jujutsu is a modern VCS with powerful features like conflict-free merging, change evolution, and seamless Git interoperability. Reponet aims to provide a native hosting platform that showcases JJ's strengths while enabling federation across instances using ActivityPub and ForgeFed.

### Goals

- **JJ-native**: First-class support for Jujutsu workflows (bookmarks, changes, conflict-free merging)
- **Git-compatible**: Push/pull with standard Git clients via JJ's Git backend
- **Federated**: Connect instances using ActivityPub/ForgeFed for decentralized collaboration
- **Self-hostable**: Run on a Raspberry Pi behind Cloudflare Tunnels

## Tech Stack

- **Language**: Elixir
- **Framework**: Phoenix + LiveView
- **Database**: PostgreSQL
- **Cache/Jobs**: Redis + Oban
- **VCS**: Jujutsu with Git backend
- **Authentication**: phx.gen.auth + GitHub OAuth (Ueberauth)
- **Federation**: ActivityPub + ForgeFed (planned)

## Development

### Prerequisites

- Elixir 1.14+
- PostgreSQL 14+
- Node.js 18+ (for assets)

### Local Setup

```bash
cd reponet

# Install dependencies
mix setup

# Start the server
mix phx.server
```

Visit [localhost:4000](http://localhost:4000).

### Docker Setup

```bash
cd reponet

# Start all services (Phoenix, PostgreSQL, Redis)
docker compose up

# Or with Podman
podman compose up
```

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp reponet/.env.example reponet/.env
```

Key variables:
- `POSTGRES_*` — Database connection
- `GITHUB_CLIENT_ID` / `GITHUB_CLIENT_SECRET` — OAuth credentials
- `SECRET_KEY_BASE` — Generate with `mix phx.gen.secret`

## Project Status

🚧 **Early Development** — Phase 1 complete

- [x] Phoenix app with PostgreSQL
- [x] Docker Compose setup (Phoenix, PostgreSQL, Redis, cloudflared)
- [x] User authentication (phx.gen.auth with LiveView)
- [x] GitHub OAuth (Ueberauth)
- [ ] JJ repository integration
- [ ] Pull request workflow
- [ ] Federation

See [outline.md](outline.md) for the full development roadmap.

## License

TBD

## Contributing

This project is in early development. Contributions welcome once the foundation is stable.
