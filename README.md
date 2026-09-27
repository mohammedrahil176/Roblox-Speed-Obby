# Roblox Speed Obby

A fully procedural, open-source "Speed Obby" game framework for Roblox, written in Luau. 

## What is this game?
This project generates a 30-stage obby from a deterministic seed instantly when the server starts. Players compete to clear the stages as fast as possible, collecting coins and avoiding obstacles. It features safe DataStore saving, server-authoritative monetization (Game Passes/Developer Products), and a robust checkpoint system.

---

## Project Structure
This repository contains raw `.lua` and `.luau` files meant to be imported into a Roblox Studio `Baseplate` place.

- `src/ServerScriptService/`: Server-side logic for generation, data saving, anti-cheat, and monetization.
- `src/ReplicatedStorage/`: Shared modules (`Config.lua`) accessible by both Server and Client.
- `src/StarterPlayer/`: Client-side UI logic for timers and shops.
- `src/Workspace/`: Object-specific mechanics (`KillBrick`, `Coin`, `Checkpoint`) used as templates for the map generator.
- `docs/`: Design documents and final audit reports.

---

## Installation & Setup Instructions

Since this project was generated as flat files outside of Studio (or without Rojo), follow these exact steps to assemble the game:

### 1. Enable Studio API Services
Before running the game, you must enable API Services so the `DataStoreManager` can save player progress.
1. Open Roblox Studio and create a new **Baseplate**.
2. Go to **Game Settings** (in the Home tab).
3. If prompted, Publish the game to Roblox.
4. Navigate to the **Security** tab.
5. Enable **"Enable Studio Access to API Services"** and click Save.

### 2. Map Scripts to Roblox Services
Create the corresponding `Script`, `LocalScript`, or `ModuleScript` inside the Roblox Explorer and paste the code from this repository into them:

- **ServerScriptService** (Create standard `Script`s here):
  - `AntiExploit.server.lua`
  - `DataStoreManager.server.lua`
  - `GameManager.server.lua`
  - `Leaderstats.server.lua`
  - `MonetizationManager.server.lua`
  - `ObbyGenerator.server.lua`

- **ReplicatedStorage** (Create a `ModuleScript` here):
  - `Config.lua`

- **StarterPlayer > StarterPlayerScripts** (Create `LocalScript`s here):
  - `ShopClient.client.lua`
  - `TimerClient.client.lua`

### 3. Setup ObbyTemplates
The `ObbyGenerator` needs access to the physical obstacle scripts to clone them into the procedurally generated map.
1. Right-click **ServerStorage** and create a new **Folder** named exactly `ObbyTemplates`.
2. Inside `ObbyTemplates`, create 5 standard `Script`s and paste their code from `src/Workspace/`:
   - `Checkpoint.server.lua`
   - `Coin.server.lua`
   - `FinishPad.server.lua`
   - `KillBrick.server.lua`
   - `SpeedPad.server.lua`

### 4. Setup GUI
The client scripts expect a specific `ScreenGui` hierarchy named `MainUI` in **StarterGui**. You will need to manually construct this layout in Studio. 
Please strictly follow the [docs/UI_SETUP.md](./docs/UI_SETUP.md) guide for the exact hierarchy and mobile-friendly styling rules!

---

## Testing the Game
1. Click **Play** in Roblox Studio.
2. The `ObbyGenerator` will instantly build all 30 stages.
3. Test dying on a KillBrick, touching a Checkpoint, and leaving the game to ensure your DataStore saves properly.

## Publishing
1. Go to the **Creator Dashboard** on the Roblox website.
2. Create your Developer Products (Skip Stage, Coins) and Game Passes (VIP).
3. Copy their IDs and paste them into `ReplicatedStorage.Config`.
4. In Studio, go to **File > Publish to Roblox**.

---

## Documentation
Please refer to the `docs/FINAL_AUDIT.md` for known limitations and technical details.
