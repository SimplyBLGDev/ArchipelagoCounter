# ArchipelagoCounter

A software tool for counting and tracking archipelago data, meant to be used to create custom layouts for streams.

## License & Attribution

This software is free to use and modify by anyone. If you use it on a stream please credit @SimplyBLG if you feel like it.

## Getting Started

1. Clone or download the repository
2. Import it into Godot 4.6.2

## Export executable

1. Export project to an exe
2. Move `APSettings.json` to the executable directory
3. Modify `APSettings.json` to contain the URL and password of your AP server, as well as the game and slots to be monitored

## Recommended custom export template
```bash
scons platform=windows target=template_release disable_3d=yes disable_physics_2d=yes disable_physics_3d=yes disable_navigation_2d=yes disable_navigation_3d=yes disable_xr=yes
```
