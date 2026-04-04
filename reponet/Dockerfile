# Dockerfile for Reponet Phoenix application
# Multi-stage build for both development and production

# ==============================================================================
# Development Stage
# ==============================================================================
FROM elixir:1.18-otp-27-alpine AS dev

# Install build dependencies and runtime tools
RUN apk add --no-cache \
    build-base \
    git \
    nodejs \
    npm \
    inotify-tools \
    postgresql-client

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set environment
ENV MIX_ENV=dev

# Copy mix files first for better caching
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy config files
COPY config config

# Compile dependencies
RUN mix deps.compile

# Copy assets for tailwind/esbuild setup
COPY assets assets
COPY priv priv

# Setup assets (downloads tailwind and esbuild binaries)
RUN mix assets.setup

# Copy remaining application code
COPY lib lib
COPY test test

# Expose port
EXPOSE 4000

# Default command for development
CMD ["mix", "phx.server"]

# ==============================================================================
# Build Stage for Production
# ==============================================================================
FROM elixir:1.18-otp-27-alpine AS build

RUN apk add --no-cache build-base git nodejs npm

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod

# Install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Build assets
COPY assets assets
COPY priv priv
RUN mix assets.setup
RUN mix assets.deploy

# Compile application
COPY config config
COPY lib lib
RUN mix compile

# Build release
RUN mix release

# ==============================================================================
# Production Stage
# ==============================================================================
FROM alpine:3.21 AS prod

RUN apk add --no-cache libstdc++ openssl ncurses-libs postgresql-client

WORKDIR /app

# Create non-root user
RUN addgroup -g 1000 reponet && \
    adduser -u 1000 -G reponet -s /bin/sh -D reponet

# Copy release from build stage
COPY --from=build --chown=reponet:reponet /app/_build/prod/rel/reponet ./

USER reponet

ENV MIX_ENV=prod
ENV PHX_SERVER=true

EXPOSE 4000

CMD ["bin/reponet", "start"]
