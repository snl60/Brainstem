========================================|========================================
                          BRAINSTEM - MAIN MENU README
========================================|========================================

This is the README document for the Main Menu scene/script of the BRAINSTEM game 
prototype project.

========================================|========================================
                                TABLE OF CONTENTS
========================================|========================================
	1. Overview
	2. Menu Layout and Interaction
	3. Audio and Music
	4. Visual Layout
	5. Key Features
	6. Known Issues

========================================|========================================
									OVERVIEW
========================================|========================================
The Main Menu in Brainstem serves as the player's entry point into the game, 
providing access to various options such as starting a new game, loading a saved 
game, adjusting settings, and viewing credits. This document details the 
functionality of the Main Menu, including its layout, interactions, and audio 
components.

========================================|========================================
							MENU LAYOUT AND INTERACTION
========================================|========================================
- **Menu Options**:

	- **Play**: Starts a new game, setting the player’s position and loading the 
				first level.

	- **Load Game**: Loads the last saved game state, allowing the player to 
					 continue from where they left off.

	- **Settings**: Opens the settings menu where players can adjust various 
					game options.

	- **Credits**: Displays the game credits, providing information about the 
				   assets used.

	- **Quit**: Exits the game. This option is hidden on platforms other than PC.


- **Focus and Navigation**:

	- When the Main Menu scene loads, focus is automatically set to the Play 
	  button.

	- The menu items are centered on the screen, ensuring a consistent and 
	  visually pleasing layout across different screen resolutions.


- **Global Variables**:

	- `Global.scene_name` is set to `"main_menu"` to track the current scene.

	- `Global.current_level` is reset to `0`, preparing the game state for a new 
	  session.

========================================|========================================
								 AUDIO AND MUSIC
========================================|========================================
- **Background Music**:

	- The Main Menu features background music that plays in a loop. This music 
	  is managed by the `AudioStreamPlayer_Music` node.

	- A timer is used to restart the music loop after it finishes playing.


- **Sound Effects**:

	- Button clicks and menu interactions should be accompanied by sound effects, 
	  enhancing the user experience. However, this has yet to be implemented.

========================================|========================================
								  VISUAL LAYOUT
========================================|========================================
- **Title Positioning**:

	- The game’s title is centered near the top of the screen. Its position is 
	  dynamically adjusted based on the viewport size.


- **Menu Positioning**:

	- The menu options are centered horizontally on the screen and positioned 
	  slightly below the title.


- **Credits Button**:

	- The Credits button is positioned at the bottom-right corner of the screen, 
	  allowing easy access without cluttering the main menu.

========================================|========================================
								  KEY FEATURES
========================================|========================================
- **Automatic HUD Removal**:

	- Upon loading the Main Menu, the HUD is automatically removed from the 
	  viewport, ensuring the player is presented with a clean menu interface.


- **Platform-Specific Adjustments**:

	- The Quit button is hidden on non-PC platforms to provide a seamless 
	  experience across different consoles.


- **Scene Transitions**:

	- When the player selects Play, the scene transitions smoothly to the first 
	  level or the level transition scene if loading a game.

========================================|========================================
								  KNOWN ISSUES
========================================|========================================
- **Load Game Feature**:

	- The load game functionality is currently not working and is commented out 
	  in the script. This feature will need to be implemented in future updates.