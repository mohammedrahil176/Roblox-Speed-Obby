# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - Initial Release

### Added
- **Procedural Obby Generator**: Automatically generates 30 unique stages using a deterministic seed (`ObbyGenerator.server.lua`).
- **Obstacle Variety**: Includes standard jumps, kill-bricks, speed pads, narrow beams, and zig-zag challenges.
- **DataStore System**: Safely saves and loads player Stage, Coins, and Wins. Includes a `loadedPlayers` check to prevent accidental data overwrites during Roblox API outages.
- **Monetization Mechanics**: Implemented Developer Products (Skip Stage, Buy Coins) and Game Passes (VIP). Safe server-authoritative validation via `ProcessReceipt`.
- **Anti-Exploit Framework**: Basic WalkSpeed verification implemented.
- **Client UI Logic**: Responsive client scripts for a Speedrun Timer and Shop Interface ready to be attached to `StarterGui`.
