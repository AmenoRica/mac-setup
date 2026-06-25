# Decisions

## Repository Purpose

This repository is the source of truth for Mac setup. Anything installed or
configured during setup should be represented here as code, package list, or
documented manual step.

## Bootstrap Strategy

The bootstrap script assumes Homebrew is installed manually first. This keeps the
first run understandable and avoids hiding a network installer inside a larger
script.

## macOS Defaults

macOS defaults are opt-in through:

```sh
RUN_MACOS_DEFAULTS=1 ./scripts/bootstrap.sh
```

This avoids surprising preference changes during ordinary package updates.

