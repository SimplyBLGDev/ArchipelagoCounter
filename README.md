# ArchipelagoCounter

A software tool for counting and tracking Archipelago data, meant to be used to create custom layouts for streams.

## License & Attribution

This software is free to use and modify by anyone for any non-commercial venture or purpose, however, this license and attribution must remain intact.

If you use it on a stream please credit @SimplyBLG (https://www.twitch.tv/simplyblg) if you feel like it and let me know.

Feel free to contact me if you want a custom layout made for you or to ask any questions.

## Getting Started

1. Clone or download the repository
2. Import it into Godot 4.6.2

## Available Layout Tools

### Glossary

```yaml
Item Code: A unique code representing an item within a game, composed of {Game Name}::{Item Name}.
	Example: "Super Mario 64::Power Star"
```

### Check Counter

Displays the total number of checks across all games in the Archipelago that have been collected so far.
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

## Configuring APSettings.json

This file is used to configure the Archipelago server and the games that will be monitored.

```yaml
archipelago_connection_data: Settings relating to the archipelago connection
	url: The URL of the Archipelago server
	password: The password of the Archipelago server
	version: Version of the Archipelago server, make sure it matches your server's AP version
		major: Major version of the Archipelago server, ex.: AP 0.7.1 -> 0
		minor: Minor version of the Archipelago server, ex.: AP 0.7.1 -> 7
		build: Build version of the Archipelago server, ex.: AP 0.7.1 -> 1
games: List of games included in the Archipelago
	slot: Slot of the game
	game: Name of the game (as it appears in the Archipelago server)
conditions: List of conditions that can be read by Layout Tools to display information about the goals of the run
	"{name of the condition}": {value of the condition}
log_colors:
	timestamp: Color used when printing the timestamp to a Log
	item: Color used when printing the item name to a Log
	location: Color used when printing the location name to a Log
	default_slot: Color used when printing a slot name to a Log
	slots:
		"{slot name}": {custom color to be used for the slot}
overrides: List of override settings, any entry here can be removed if not needed
	games:
		{name of the game}:
			data_package_file: path to a custom data package file to be used when loading the game, relative to the executable
			exclude_location: List of regex compatible patterns, locations matching any of these patterns will not count towards the check counter
```

## Export executable

1. Export project to an exe
2. Move `APSettings.json` to the executable directory
3. Modify `APSettings.json` to contain the URL and password of your AP server, as well as the game and slots to be monitored

## Recommended custom export template (optimized for file size)

Replace platform parameter as needed:
```
scons platform=<windows/linux> target=template_release disable_3d=yes disable_physics_2d=yes disable_physics_3d=yes disable_navigation_2d=yes disable_navigation_3d=yes disable_xr=yes
```
