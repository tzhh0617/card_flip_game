# Audio Files Needed

Place the following audio files in this directory:

| File | Description | Duration | Format |
|------|-------------|----------|--------|
| flip.mp3 | Card flip sound | ~0.2s | MP3 |
| match.mp3 | Successful match | ~0.5s | MP3 |
| wrong.mp3 | Mismatch sound | ~0.3s | MP3 |
| combo.mp3 | Combo achievement | ~0.5s | MP3 |
| win.mp3 | Level complete | ~1.5s | MP3 |
| cheer.mp3 | Children cheering | ~2s | MP3 |
| star_collect.mp3 | Star collection | ~0.3s | MP3 |
| button.mp3 | Button click | ~0.1s | MP3 |

## Recommended Sources (Free)

1. **Freesound.org** - Free sound effects (CC0/CC-BY)
2. **OpenGameArt.org** - Game-specific sounds
3. **Mixkit.co** - Free sound effects
4. **Zapsplat.com** - Large sound library

## Tips for Child-Friendly Sounds

- Use bright, cheerful tones
- Avoid harsh or startling sounds
- Keep volumes moderate
- Test with actual children if possible

## After Adding Files

Uncomment the FlameAudio.play() calls in:
`lib/game/managers/audio_manager.dart`
