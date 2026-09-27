# Game Design: Speed Obby

## Core Loop
1. Spawn at Stage 1.
2. Complete obstacles to reach the next checkpoint (Stages 1-30).
3. Collect coins along the way or find speed boost pads.
4. Reach Stage 30 to finish the obby, receive a large coin reward, and a "Win" added to leaderstats.
5. Rebirth or reset to replay for a better time or more coins.

## Mechanics
- **Checkpoints**: When a player touches a checkpoint part, their `Stage` leaderstat updates, and their respawn location changes.
- **Kill Bricks**: Red/neon parts that instantly kill the player.
- **Speed Pads**: Green parts that temporarily boost walk speed to help clear large jumps.
- **Coins**: Collectibles that grant +1 Coin and respawn after a short delay.
- **Timer**: A UI timer tracking how long the player takes to reach the end.

## UI
- **Mobile-Friendly**: All buttons will use standard `TextButton` or `ImageButton` with `Scale` sizing (not `Offset`) so they fit all screens.
- **Top Bar**: Shows current Stage, Coins, and Time.
- **Shop**: A left-side button opening a frame with Game Passes and Dev Products.
