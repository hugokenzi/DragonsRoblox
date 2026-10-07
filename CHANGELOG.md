# Changelog

All notable changes to this project are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This project doesn't use version numbers yet (pre-release prototype) — entries are grouped by work session instead.

## [Unreleased]

### Changed
- Dropped Rojo/Rokit as the Studio sync method. `src/` stays the reference source (and the folder-per-service layout is kept), but code is now copied into Studio by hand instead of auto-synced. `rokit.toml` and `default.project.json` removed; Rojo's plugin and Rokit uninstalled from the machine. See [README.md](README.md) for the manual copy-paste mapping.
- Player-facing text (UI, console output, announcements) switched to English; code comments stay in French.

### Added
- `src/shared`, `src/server`, `src/client` project layout.
- `Config` module (shared) holding every tunable value from the brief: save settings, rarities, mount stats, egg weights/timers, incubation durations, mutation/size odds, flight settings, zone 1 layout.
- `Remotes` module (shared): central RemoteEvent registry, created by the server and waited on by the client.
- `WeightedRandom` module (shared): weighted-pick helper used for rarity/mutation/size rolls.
- `DragonStats` module (shared): computes a dragon's mount stats and income from its rarity/mutation/size.
- `DataService` (server): loads/saves player data with `DataStoreService`, retries on failure, auto-saves every 60s, saves on leave and on server shutdown (`BindToClose`); falls back to in-memory data without crashing when the place hasn't been published yet. Syncs money to `leaderstats`.
- `WorldService` (server): procedurally builds zone 1 at server start — ground, a snow-capped mountain (~200 studs), a lake with a sandy shore, a 130-tree forest around spawn, invisible boundary walls, hard-to-reach spots for rare eggs (mountain peak, ledges, floating islands), and the spawn point. Regenerates every Play session since Terrain isn't version-controlled.
- `DragonService` (server, in progress): dragon inventory (create/grant starter dragon, choose mount, perches) and per-second income for parked dragons.
- Git repository, pushed to [github.com/hugokenzi/DragonsRoblox](https://github.com/hugokenzi/DragonsRoblox).
