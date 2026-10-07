# DragonsRoblox

A Roblox dragon-collecting game. Players fly their dragon mount to be the first to grab eggs, bring them back to their base to hatch, and the hatched dragons generate money based on their rarity.

Inspired by *Steal An Egg* (eggs, hatching, income, base) and *Ride A Pet* (mounts to reach farther eggs). What sets this game apart: **dragons fly**. High-altitude zones, aerial shortcuts, and a flight feel that's meant to be fun on its own.

The full game design brief lives in [BRIEF.md](BRIEF.md) (in French — it's the source of truth for gameplay decisions).

## Tech stack

- **Roblox Studio** + **Luau**, `--!strict` where reasonable.
- No build/sync tool: the code in `src/` is the reference source, copied by hand into matching scripts in Roblox Studio (see below).
- Code is in English; comments are in French (the project owner is a French-speaking Roblox beginner).

## Project structure

```
src/
  shared/   -> ReplicatedStorage > Shared     (Config, remotes, shared helpers)
  server/   -> ServerScriptService > Server   (data, world, eggs, dragons, economy)
  client/   -> StarterPlayer > StarterPlayerScripts > Client (flight controls, HUD)
```

## Getting the code into Studio

There's no sync tool — copy the files by hand:

1. In Roblox Studio's Explorer, create a `Folder` named `Shared` under `ReplicatedStorage`, a `Folder` named `Server` under `ServerScriptService`, and a `Folder` named `Client` under `StarterPlayer > StarterPlayerScripts`. Recreate any subfolders from `src/` the same way (e.g. `src/server/Services` -> a `Services` folder inside `Server`).
2. For each file in `src/`, create a matching instance in the right folder:
   - `*.server.luau` -> a `Script`
   - `*.client.luau` -> a `LocalScript`
   - anything else -> a `ModuleScript`
   - name the instance after the file, without the extension (`DataService.luau` -> `DataService`)
3. Copy the file's contents (e.g. open it in VS Code) and paste it into that instance's script editor in Studio.
4. Press **Play**. The output should show `Server DragonsRoblox started` and `Client DragonsRoblox started`.

Data is saved with `DataStoreService`. In Studio, it only works once the place has been published at least once (**File > Publish to Roblox**); until then the game runs normally but nothing persists between sessions.

See [CHANGELOG.md](CHANGELOG.md) for what's been built so far.
