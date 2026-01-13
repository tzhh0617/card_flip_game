# Theme Cover Images

This directory should contain cover/banner images for each animation theme.

## Required Images

| Filename | Theme | Size |
|----------|-------|------|
| paw_patrol.png | 汪汪队立大功 | 400x300 |
| peppa_pig.png | 小猪佩奇 | 400x300 |
| bluey.png | Bluey | 400x300 |
| super_wings.png | 超级飞侠 | 400x300 |
| thomas.png | 托马斯小火车 | 400x300 |
| boonie_bears.png | 熊出没 | 400x300 |
| robocar_poli.png | 变形警车珀利 | 400x300 |
| my_little_pony.png | 小马宝莉 | 400x300 |
| pleasant_goat.png | 喜羊羊与灰太狼 | 400x300 |
| chick_squad.png | 萌鸡小队 | 400x300 |

## Current Placeholder Behavior

The game currently uses solid color cards with emoji icons and theme names.
This provides a good visual experience without actual images.

## Adding Real Images

1. Add PNG files to this directory
2. Update `pubspec.yaml`:
   ```yaml
   assets:
     - assets/images/themes/
   ```
3. Update `HomeScreen` to use `Image.asset()` for theme cards
