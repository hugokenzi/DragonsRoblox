# Changelog

All notable changes to this project are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This project doesn't use version numbers yet (pre-release prototype) — entries are grouped by work session instead.

## [Unreleased]

### Added
- Rojo project scaffold: `src/shared`, `src/server`, `src/client`, synced via Rojo 7.7.0 / Rokit.
- `Config` module (shared) holding every tunable value (save settings, rarities, mount stats, egg weights, incubation durations, mutation/size odds).
- `DataService` (server): loads/saves player data with `DataStoreService`, retries on failure, auto-saves every 60s, saves on leave and on server shutdown (`BindToClose`); falls back to in-memory data without crashing when the place hasn't been published yet.
- Money display via `leaderstats`.
- Git repository, pushed to [github.com/hugokenzi/DragonsRoblox](https://github.com/hugokenzi/DragonsRoblox).
