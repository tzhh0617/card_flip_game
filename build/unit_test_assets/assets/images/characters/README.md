# Character Card Images

This directory should contain character images for each theme.

## Directory Structure

Create subdirectories for each theme:

```
characters/
├── paw_patrol/
│   ├── 毛毛.png
│   ├── 阿奇.png
│   ├── 天天.png
│   └── ... (10 characters)
├── peppa_pig/
│   ├── 佩奇.png
│   ├── 乔治.png
│   └── ...
├── bluey/
├── super_wings/
├── thomas/
├── boonie_bears/
├── robocar_poli/
├── my_little_pony/
├── pleasant_goat/
└── chick_squad/
```

## Image Specifications

- **Size**: 200x200 pixels (will be scaled)
- **Format**: PNG with transparency
- **Style**: Cartoon, child-friendly, bright colors

## Current Placeholder Behavior

The game currently uses colored rectangles with character names as text.
This works well for testing and prototyping.

## Adding Real Images

1. Add PNG files to the appropriate theme subdirectory
2. Update `pubspec.yaml` to include:
   ```yaml
   assets:
     - assets/images/characters/paw_patrol/
     - assets/images/characters/peppa_pig/
     # ... etc
   ```
3. Update `CardComponent` to load and display images:
   ```dart
   final sprite = await Sprite.load('characters/paw_patrol/毛毛.png');
   ```
