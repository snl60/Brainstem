========================================|========================================
                           BRAINSTEM - LEVEL 2 README
========================================|========================================

This is the README document for Level 2 of the BRAINSTEM game prototype project.

========================================|========================================
                                TABLE OF CONTENTS
========================================|========================================
	1. Overview
	2. Scene Setup
	3. Player Interaction
	4. Visual and Audio Effects
	5. Key Features
	6. Known Issues

========================================|========================================
									OVERVIEW
========================================|========================================
Level 2 in Brainstem is a complex stage that builds on the foundational mechanics
introduced in Level 1. This level introduces the player to a variety of terminals
and upgrades, each unlocking new abilities or progressing the storyline. The 
environment is interactive, requiring the player to solve puzzles and engage in 
combat while navigating through the level.

========================================|========================================
								   SCENE SETUP
========================================|========================================
- **Initialization**:

	- Upon loading, the player's position and the state of the level are initialized.

	- Global variables are updated:
		- Global.current_level is set to 2.
		- Global.scene_name is set to "level_2".

	- The level begins with a fade-in effect to smoothly transition the player into the scene.

  
- **Global Variables**:

	- `Global.current_level` is set to `2` to indicate the player is in Level 2.

	- `Global.scene_name` is updated to `"level_2"`.

========================================|========================================
							   PLAYER INTERACTION
========================================|========================================
- **Terminals and Upgrades**:

	- The player interacts with six different terminals, each unlocking specific 
	  abilities or allowing progression.

	- Terminals are associated with mini-games that must be completed to unlock 
	  them.

	- Upgrades available in this level include Double Jump, Electricity 
	  Imbuement, and Slide.


- **Elevators**:

	- Multiple elevators connect different floors. The player must unlock 
	  terminals to use these elevators.

	- Elevators require successful mini-game completion or a specific upgrade 
	  to activate.


- **Scene Transitions**:

	- Players can transition back to Level 1 or progress deeper into Level 2 by 
	  interacting with specific areas or using elevators.

========================================|========================================
							VISUAL AND AUDIO EFFECTS
========================================|========================================
- **Fade-In/Out Animations**:

	- The level begins with a fade-in effect using the `transition_fade_in()` 
	  function.

	- Transitions between different areas or levels are handled with a fade-out 
	  effect to ensure a smooth visual experience.


- **Dialogue**:

	- All dialogue was created using the Dialogic addon.

	- Opening dialogue and other significant story moments are triggered after 
	  specific events, adding narrative depth to the level.

- **Music**:

	- The music for this level is an original composition by Scott Lopez.

========================================|========================================
								  KEY FEATURES
========================================|========================================
- **Interactive Terminals**:

	- Six terminals, each with unique puzzles or mini-games that must be solved 
	  to unlock new areas or abilities.


- **Environmental Interactions**:

	- The level includes various environmental puzzles, such as unlocking gates 
	  or activating elevators, requiring strategic thinking.


- **Upgrades**:

	- Players gain new abilities like Double Jump, Electricity Imbuement, and 
	  Slide, essential for progressing through the game.


========================================|========================================
								  KNOWN ISSUES
========================================|========================================
- **Save Game Feature**:

	- The save game functionality is currently not working and is commented out 
	  in the script. This feature will need to be implemented in future updates.