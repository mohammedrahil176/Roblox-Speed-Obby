# Monetization Strategy

## Principles
- No fake Robux generators.
- No pay-to-win mechanics that ruin the fun, only shortcuts or fun extras.
- Use official Roblox API (`MarketplaceService`).

## Developer Products (Consumables)
- **+100 Coins** (10 Robux): Gives the player 100 coins instantly.
- **+500 Coins** (40 Robux): Gives 500 coins.
- **Skip Stage** (25 Robux): Instantly teleports the player to the next checkpoint and updates their stage.

## Game Passes (Permanent)
- **VIP** (99 Robux): Gives a chat tag "[VIP]", a golden trail effect, and 2x Coin multiplier.
- **Coil Pack** (149 Robux): Grants a Gravity Coil (jump boost) and Speed Coil (walk speed boost) on spawn.
- **Rainbow Trail** (49 Robux): Equips a rainbow particle trail to the character.

## Implementation Details
- Dev Products will be handled in `MonetizationManager.server.lua` via `MarketplaceService.ProcessReceipt`.
- Game Passes will be checked on `PlayerAdded` via `UserOwnsGamePassAsync`.
