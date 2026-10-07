# DragonsRoblox

A Roblox dragon-collecting game. Players fly their dragon mount to be the first to grab eggs, bring them back to their base to hatch, and the hatched dragons generate money based on their rarity.

Inspired by *Steal An Egg* (eggs, hatching, income, base) and *Ride A Pet* (mounts to reach farther eggs). What sets this game apart: **dragons fly**. High-altitude zones, aerial shortcuts, and a flight feel that's meant to be fun on its own.

The full game design brief lives in [BRIEF.md](BRIEF.md) (in French — it's the source of truth for gameplay decisions).

## Tech stack

- **Roblox Studio** + **Rojo 7.7.0** (installed via [Rokit](https://github.com/rojo-rbx/rokit)) to sync code between this repo and Studio.
- **Luau**, with `--!strict` where reasonable.
- Code is in English; comments are in French (the project owner is a French-speaking Roblox beginner).

## Project structure

```
src/
  shared/   -> ReplicatedStorage.Shared   (Config, remotes, shared helpers)
  server/   -> ServerScriptService.Server (data, world, eggs, dragons, economy)
  client/   -> StarterPlayer.StarterPlayerScripts.Client (flight controls, HUD)
```

## Setup (one time)

1. Install [Rokit](https://github.com/rojo-rbx/rokit) (toolchain manager).
2. From this folder: `rokit install` (installs Rojo per `rokit.toml`).
3. `rojo plugin install` (installs the Rojo plugin in Roblox Studio — restart Studio if it was open).

## Working on the project

1. `rojo serve`
2. In Roblox Studio: **Plugins > Rojo > Connect**.
3. Press **Play**. The output should show `Server DragonsRoblox started` and `Client DragonsRoblox started`.
4. Edit code under `src/` (with VS Code or an AI coding assistant) — Rojo pushes changes to Studio automatically.

Data is saved with `DataStoreService`. In Studio, `DataStoreService` only works once the place has been published at least once (**File > Publish to Roblox**); until then the game runs normally but nothing persists between sessions.

See [CHANGELOG.md](CHANGELOG.md) for what's been built so far.
