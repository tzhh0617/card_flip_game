# Effect Images

This directory is for special effect sprites if needed.

## Potential Uses

- Custom star shapes for star burst effect
- Custom heart shapes for heart rain
- Firework particle textures
- Trophy image for celebrations

## Current Implementation

All effects are currently implemented using Flame's shape components:
- `CircleComponent` for particles
- `RectangleComponent` for confetti and shapes
- Built-in effects for animations

This approach:
- Requires no external assets
- Has smaller app size
- Works consistently across platforms
- Is easy to customize with code

## Optional Enhancements

If you want richer visuals, you can add:
- `star.png` - Golden star sprite
- `heart.png` - Pink/red heart sprite
- `firework_particle.png` - Glowing particle
- `trophy.png` - Trophy icon

Then update the effect classes to use `SpriteComponent` instead of shape components.
