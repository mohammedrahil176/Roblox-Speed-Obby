# UI Setup Guide

Because this codebase is generated outside of Studio, you must physically build the `ScreenGui` elements inside Roblox Studio. The scripts (`MainUIClient.client.lua` and `ShopClient.client.lua`) strictly expect the following exact naming and hierarchy. 

Create everything below inside `StarterGui`.

## Exact Hierarchy required:

```text
StarterGui
└── MainUI (ScreenGui)
    ├── TopHUD (Frame)
    │   ├── StageLabel (TextLabel)
    │   ├── CoinsLabel (TextLabel)
    │   ├── TimerLabel (TextLabel)
    │   ├── WinsLabel (TextLabel)
    │   └── UIListLayout (Optional, for auto-alignment)
    │
    ├── NotificationFrame (Frame)
    │   ├── TextLabel (TextLabel)  -- For "Stage X!" popup
    │   └── UICorner (Optional, for rounded edges)
    │
    ├── FinishFrame (Frame)
    │   ├── TitleLabel (TextLabel) -- "Course Completed!"
    │   ├── TimeLabel (TextLabel)  -- The script will insert the final time here
    │   └── RestartButton (TextButton)
    │
    ├── ShopButton (TextButton) -- Open/Close shop
    │
    └── ShopFrame (Frame)
        ├── TitleLabel (TextLabel) -- "Shop"
        ├── FeedbackLabel (TextLabel) -- Shows "Purchase Successful/Cancelled"
        └── ScrollingFrame (ScrollingFrame)
            ├── UIListLayout (For stacking buttons)
            ├── BuySkipButton (TextButton)
            ├── BuyCoinsButton (TextButton)
            └── BuyVIPButton (TextButton)
```

## Mobile-Friendly Design Tips

When building these elements in Studio, follow these rules to ensure they work on mobile phones:

1. **Use `Scale`, not `Offset`**:
   - In the `Size` and `Position` properties of every Frame and Button, use the first and third numbers (Scale). 
   - Example: `UDim2.new(0.5, 0, 0.1, 0)` means 50% width and 10% height. Do not use `UDim2.new(0, 200, 0, 50)`.
   - This ensures the UI scales correctly on a tiny phone screen and a massive ultra-wide monitor.

2. **Touch-Friendly Button Sizes**:
   - Make `ShopButton` and `RestartButton` large enough for a thumb to easily tap. A height of `0.1` (10% of screen height) is usually good for mobile buttons.

3. **TextScaling**:
   - Enable `TextScaled = true` on every `TextLabel` and `TextButton`.
   - Add a `UITextSizeConstraint` if the text gets too large on PC screens.

4. **Visibility Defaults**:
   - Set the `Visible` property of `NotificationFrame`, `FinishFrame`, and `ShopFrame` to **`false`** in the Properties window. The scripts will automatically make them visible when needed.

5. **Aesthetics**:
   - Add `UICorner` objects inside your Frames and Buttons for modern rounded corners.
   - Add `UIStroke` objects for clean outlines around text and frames.
