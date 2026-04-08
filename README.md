# ArchipelagoCounter

A software tool for counting and tracking archipelago data, meant to be used to create custom layouts for streams.

## License & Attribution

This software is free to use and modify by anyone. If you use it on a stream please credit @SimplyBLG (twitch.tv/simplyblg) if you feel like it.

## Getting Started

1. Clone or download the repository
2. Import it into Godot 4.6.2

## Available Layout Tools

### Glossary

```yaml
Item Code: A unique code representing an item within a game, composed of {Name}::{Item Name}.
    Example: "Super Mario 64::Power Star"
```

### Check Counter

Displays the total number of checks across all games in the archipelago that have been collected so far.
The total is automatically calculated on startup.

Parameters:

```yaml
text_format: String to be formatted with the count, {0} will be replaced with the count, {1} will be replaced with the total.
```

### Item

Displays the current state of a particular item, being transparent when the item is missing and opaque when found.

Parameters:

```yaml
item_code: The code of the item to be tracked
threshold: Amount of items required to be collected for the item to be considered found
missing_texture_mode: The type of texture filter to use when the item is missing.
    SEMI_TRANSPARENT_BW: Semi-transparent black and white texture
    SEMI_TRANSPARENT_BW_INVERTED: Semi-transparent black and white texture, but inverted
```

### ItemAtlas

Displays the amount of items of a particular type that have been collected so far, using frames of a texture atlas to represent the item in different stages.

Parameters:

```yaml
item_code: The code of the item to be tracked
frames_in_atlas: The number of frames in the texture atlas
```

### ItemCounter

Displays the amount of items of a particular type that have been collected so far.

Parameters:

```yaml
items: The codes of items that count towards the count.
text_format: String to be formatted with the count, {0} will be replaced with the count, {1} will be replaced with the total.
condition: condition to be fetched for the total.
```

### Log

Displays a textbox describing all received items of all games in order.

Parameters:

```yaml
text_format: String to be formatted for an item entry, the following substrings will be replaced:
    {timestamp}: The timestamp of the event
    {sender}: Name of the slot that sent the item
    {receiver}: Name of the slot that received the item
    {item}: The name of the item that was sent
    {location}: The location where the item was found
    {timestamp_color}: Color of the timestamp (defined in APSettings.json)
    {sender_color}: Color of the sender (defined in APSettings.json)
    {receiver_color}: Color of the receiver (defined in APSettings.json)
    {item_color}: Color of the item (defined in APSettings.json)
    {location_color}: Color of the location (defined in APSettings.json)
```

### PendingItems

Displays a list of all *progression* items per game that have been collected since the last time that game was opened.

### StarCounter

Displays the amount of Super Mario 64 stars that have been collected so far.

## Export executable

1. Export project to an exe
2. Move `APSettings.json` to the executable directory
3. Modify `APSettings.json` to contain the URL and password of your AP server, as well as the game and slots to be monitored

## Recommended custom export template
```
scons platform=windows target=template_release disable_3d=yes disable_physics_2d=yes disable_physics_3d=yes disable_navigation_2d=yes disable_navigation_3d=yes disable_xr=yes
```
