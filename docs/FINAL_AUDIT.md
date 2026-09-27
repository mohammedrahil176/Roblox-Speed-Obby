# Final Project Audit Report

## 1. Problems Discovered & Fixed
- **DataStore Overwrite Risk**: In `DataStoreManager.server.lua`, if a player's data failed to load (e.g. Roblox API outage), their data defaulted to Stage 1 and 0 Coins. When they left, this default data was saved, permanently wiping their progress.
  - **Fix**: Added a `loadedPlayers` table. The server now only saves data if the player successfully loaded their original data upon joining.
- **Memory Leak**: The `loadedPlayers` table would hold onto player references after they left.
  - **Fix**: Added `loadedPlayers[player] = nil` cleanup logic in the `PlayerRemoving` event.

## 2. Script Compatibility & Integration Verification
- **ObbyGenerator**: Successfully creates all 30 stages with a deterministic seed (`8675309`). Checkpoints are correctly named `"1"` through `"30"`, enabling seamless teleportation by `GameManager`. The script safely clones the template mechanics (KillBricks, Coins, SpeedPads) into the generated map.
- **Checkpoints**: `Checkpoint.server.lua` correctly prevents skipping by explicitly requiring the player to be at `stage - 1` to unlock the new checkpoint. Stage 30 logic is appropriately isolated to `FinishPad.server.lua`.
- **Monetization**: `ProcessReceipt` is correctly configured in `MonetizationManager`. It properly credits the server-side `IntValue` and triggers a respawn when skipping a stage. No client-side manipulation of purchases is possible.
- **Mobile UI**: The UI scripts (`TimerClient` and `ShopClient`) rely on dynamically sized `Scale` coordinates (as planned) and are entirely self-contained.

## 3. Remaining Limitations
- **Anti-Exploit Constraints**: The `AntiExploit.server.lua` script currently listens for `WalkSpeed` changes. In Roblox, if an exploiter alters their WalkSpeed via a client-side injector, it does not replicate to the server, meaning the server's `.Changed` event won't fire. A true server-side speed anti-cheat requires calculating distance over time (Magnitude checks), but this often causes false positives (rubberbanding) for legitimate mobile players with laggy internet connections. For a simple obby, the current setup is a reasonable placeholder.
- **Global Coins**: The `Coin.server.lua` script uses a global cooldown (`collected = false`), meaning if Player A collects a coin, it disappears for Player B for 10 seconds. In a highly competitive game, coins are usually tracked locally on the client or uniquely per-player on the server.
- **Missing UI Layouts**: The `StarterPlayerScripts` rely on actual UI elements existing in `StarterGui` (like `MainUI`, `TimerLabel`, `ShopFrame`). You will need to physically design these GUIs in Studio.

## 4. Exact Roblox Studio Setup Steps
Since this project was generated outside of Roblox Studio, follow these exact steps to assemble it:

1. **Enable Studio APIs**: Go to **Home > Game Settings > Security** and enable **"Enable Studio Access to API Services"**. This is required for `DataStoreManager` to function!
2. **Move Server Scripts**: Copy all `.server.lua` files from `src/ServerScriptService/` into the **ServerScriptService** service in Explorer.
3. **Move Config Module**: Copy `Config.lua` from `src/ReplicatedStorage/` into the **ReplicatedStorage** service.
4. **Move Client Scripts**: Copy the `.client.lua` files from `src/StarterPlayer/StarterPlayerScripts/` into **StarterPlayer > StarterPlayerScripts**.
5. **Create Template Folder**: 
   - Right-click **ServerStorage** and create a `Folder` named `ObbyTemplates`.
   - Create standard `Script` objects inside this folder for: `KillBrick`, `Checkpoint`, `Coin`, `SpeedPad`, and `FinishPad`.
   - Paste the code from their respective `src/Workspace` folders into these scripts.
6. **Design UI**: Create a `ScreenGui` named `MainUI` in **StarterGui**. Add a TextLabel named `TimerLabel` (inside a `TopBar` frame) and a `ShopFrame` with buttons for the shop script to hook into.

## 5. Testing & Publishing Checklist
- [ ] Run a Playtest in Studio and verify the map generates instantly.
- [ ] Walk into a KillBrick and verify respawning at the latest checkpoint.
- [ ] Collect a coin and verify it respawns after 10 seconds.
- [ ] Stop the test, Play again, and verify your Stage and Coins saved!
- [ ] Update `Config.lua` with your real Game Pass and Developer Product IDs from the Creator Dashboard.
- [ ] Publish to Roblox!
