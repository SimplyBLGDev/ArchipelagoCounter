# ArchipelagoCounter

A multigame multiworld tracker for Archipelago, capable of tracking and displaying the status of every game in an Archipelago, can be customized for any layout.
Intended for streamers and multigame runs but can be used by anyone.

## License & Attribution

This software is free to use and modify by anyone for any non-commercial venture or purpose, however, this license and attribution must remain intact.

If you use it on a stream please credit @SimplyBLG (https://www.twitch.tv/simplyblg) if you feel like it and let me know.

Feel free to contact me if you want a custom layout made for you or to ask any questions.

## Preview
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/072186ef-684e-4d47-b75b-607000dddb17" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/800cc6ac-9570-48a3-80ee-3b6578976b4f" />
<img width="1919" height="1080" alt="image" src="https://github.com/user-attachments/assets/41ba0922-1ce7-4700-86f4-4c3710d86d09" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/495d16c7-0244-4f63-911b-bb484b0beb7c" />

## Getting Started

1. Clone or download the repository
2. Import it into Godot 4.6.2
3. Modify the example layouts with whatever you're gonna use (Some basic Godot knowledge required)
4. Configure APSettings.json (see `Configuring APSettings.json` section in this README)
5. Run the project from Godot to test or see `Export executable` section in this README

## Available Layout Tools

### Glossary

```yaml
Item Code: A unique code representing an item within a game, composed of {Slot Name}::{Item Name}.
	Example: "BLGSM64::Power Star"
```

### Figuring out Item codes

If you need to get the correct item code for any particular game you can go to the Counter.gd file in the Godot script editor and breakpoint line `process_save()` under the `_ready()` method (by left clicking the far left margin next to the line, a red dot should appear), this will stop the execution of the program after fetching all the item codes from your games and you can then open the `item_lookup` variable.

### Check Counter

Displays the total number of checks across all games in the Archipelago that have been collected so far.
The total is automatically calculated on startup.

Base class: `Label`

Parameters:

```yaml
text_format: String to be formatted with the count, {0} will be replaced with the count, {1} will be replaced with the total.
```

### CheckCounterAdvanced

Displays the total number of checks, current checks found, percentage of checks to the total, and checks per minute of either a particular slot or the entire AP.

Base class: `Label`

Parameters:
```yaml
text_format: String to be formatted with the count, {0} will be replaced with the count, {1} will be replaced with the total, {2} will be replaced with the percentage, {3} will be replaced with the checks per minute
game: slot of the game to be tracked
```

### CompletionIndicator

Displays a texture if a particular game has been completed.

Base class: `TextureRect`

Parameters:

```yaml
slot: slot of the game to be tracked
```

### Item

Displays the current state of a particular item, being transparent when the item is missing and opaque when found.

Base class: `TextureRect`

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

Base class: `TextureRect`

Parameters:

```yaml
item_code: The code of the item to be tracked
frames_in_atlas: The number of frames in the texture atlas
```

### ItemCounter

Displays the amount of items of a particular type that have been collected so far.

Base class: `Label`

Parameters:

```yaml
items: The codes of items that count towards the count.
text_format: String to be formatted with the count, {0} will be replaced with the count, {1} will be replaced with the total.
condition: condition to be fetched for the total.
```

### Log

Displays a textbox describing all received items of all games in order.

Base class: `RichTextLabel`

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

### DeathlinkCounter

Displays the amount of deaths of a particular slot.

Base class: `Label`

Parameters:

```yaml
text_format: String to be formatted with the count, {0} will be replaced with the count
slot: The slot of the game to be tracked
```


### PendingItems

Displays a list of all *progression* items per game that have been collected since the last time that game was opened.

Base class: use `LayoutTool_PendingItems.tscn`

### AdvancedTimer

Displays the amount of time spent in a particular slot.

Base class: `Label`

Parameters:

```yaml
text_format: String to be formatted with the time, {0} will be replaced with the time, {1} will be replaced with the percentage of the total time represented by the slot's time
game: The slot of the game to be tracked
```

### MultiView

Alternates between the children of the node to show one at a time over time in regular intervals.

Base class: `Control`

Parameters:

```yaml
view_change_speed: Time in seconds between each switch
fade_time: Time in seconds for the fade in/out of each switch
```

### ProgressPanel

Converts a control node into a progress bar representing the ratio of checks to total checks of a particular slot.

Base class: `Control`

Parameters:

```yaml
color_rect: A Color rect node to be used
game: The slot of the game to be tracked
```

### RunTimer

Displays the amount of time spent in the current run.

Base class: `Label`

### StarCounter

Displays the amount of Super Mario 64 stars that have been collected so far.

Base class: use `LayoutTool_StarCounter.tscn`

Parameters:

```yaml
slot: The slot of the game to be tracked
```

### AnimatedLog

Displays a log of all events that have been received by the Archipelago server, new items pop in from the bottom with a small animation, optimal for streams.

Base class: use `LayoutTool_AnimatedLog.tscn`

Parameters:

```yaml
message_template: String to be formatted for an item entry, the following substrings will be replaced:
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
print_excluded_locations: If true the location will be printed even if it's excluded
```

### Launcher

Generates a dropdown of all slots and allows you to 'launch' any given slot to start it with everything you may need.

Base class: use `LayoutTool_Launcher.tscn`

This node is configured through a file `APAutoLauncher.json` in the same directory as you executable, view the included `APAutoLauncher.json` file for an example of what this file should look like.

Parameters:

```yaml
poptracker_path: The path to the poptracker executable
slots: A list of all slots and their launch settings
	slot: Name of the slot
	actions: List of actions to take when launching the slot
		action: The type of action to take (see below)
```

#### Action types:

##### Command: Runs a powershell (Windows) or bash (Linux) command directly
```yaml
action: "Command"
command: The command to run
```

##### Launch: Launches an executable from its path context
```yaml
action: "Launch"
path: The path to the executable
```

##### Poptracker: Opens poptracker to a specified pack and variant
```yaml
action: "Poptracker"
pack: The pack to open, check the pack's manifest.json for the pack name
variant: The variant of the pack to open, check the pack's manifest.json for the variant name
```

##### APFile: Opens an AP file
```yaml
action: "APFile"
directory: The directory containing the file
extension: The extension of the file to open, make sure there is only one file with this extension in the directory, if you need to open multiple files use the Command or Launch action
```

### Notes

Allows you to keep track of anything you need to remember in your slots by providing a text box where you can write notes, some games have additional notes features.

Base class: use `LayoutTool_Notes.tscn`

#### Games with additional notes features:

- Ship of Harkinian: Shop tracker
- Majora's Mask Recompiled: Shop tracker
- Super Mario 64: Entrance tracker

### UI_BG

__Advanced node__, purely decorative.

Displays a background with slowly scrolling items, in order to use it you can generate the individual images of the items using UI_BG_Generator and placing the results in the APBGElements folder next to the executable.

## Configuring APSettings.json

This file is used to configure the Archipelago server and the games that will be monitored.
All files used by APCounter are read from the same directory as the executable, if you're running from Godot make sure that all files are in the same directory as the **Godot.exe executable**. If the project is exported make sure all files are in the same directory as the **APCounter.exe executable**.

```yaml
archipelago_connection_data: Settings relating to the archipelago connection
	url: The URL of the Archipelago server, if it's a local server (localhost) prefix it with ws://, if it's a remote server (e.g. archipelago.gg) prefix it with wss://
	password: The password of the Archipelago server
	version: Version of the Archipelago server, make sure it matches your server's AP version
		major: Major version of the Archipelago server, ex.: AP 0.7.1 -> 0
		minor: Minor version of the Archipelago server, ex.: AP 0.7.1 -> 7
		build: Build version of the Archipelago server, ex.: AP 0.7.1 -> 1
games: List of games included in the Archipelago
	slot: Slot of the game
	game: Name of the game (as it appears in the Archipelago server)
conditions: List of conditions that can be read by Layout Tools to display information about the goals of the run, arbitrary names
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
scons platform=<windows|linux> target=template_release disable_3d=yes disable_physics_2d=yes disable_physics_3d=yes disable_navigation_2d=yes disable_navigation_3d=yes disable_xr=yes
```
