========================================|========================================
                                    BRAINSTEM
								  LEVEL 1 README
========================================|========================================

This is the README document for Level 1 of the BRAINSTEM game prototype project.

========================================|========================================
                                TABLE OF CONTENTS
========================================|========================================
	1. Overview
	2. Scene Setup
	3. Player Interaction
	4. Visual and Audio Effects
	5. Known Issues

========================================|========================================
									OVERVIEW
========================================|========================================
Welcome to Level 1 of BRAINSTEM. This level serves as the introductory stage, 
setting the tone for the game's dystopian world. Players will begin their journey 
here, navigating the environment and learning the basic mechanics of movement, 
interaction, and transitioning between levels.

========================================|========================================
								   SCENE SETUP
========================================|========================================
- **Initialization**: When the scene is loaded, the player's position is 
					  determined by whether they are continuing from Level 2 or 
					  starting fresh.

	- If the player is coming from Level 2, their position is set near the 
	  entrance, and their sprite is flipped horizontally to face the appropriate 
	  direction.

	- The level initializes with a fade-in from black, providing a smooth visual 
	  transition.


- **Global Variables**:

	- Global.scene_name is set to "level_1" to track the current scene.

	- Global.current_level is updated to 1 to indicate the player is in Level 1.

========================================|========================================
							   PLAYER INTERACTION
========================================|========================================
- **Transitioning to Level 2**:

	- When the player reaches the door to Level 2, a transition begins with a 
	  fade-out effect.

	- The player's movement is paused (is_input_paused = true), and the 
	  transition timer ($Timer_Transition) is started.

	- Upon timer completion, the scene transitions to Level 2.

========================================|========================================
							VISUAL AND AUDIO EFFECTS
========================================|========================================
- **Fade-In/Out Animations**:

	- The level begins with a fade-in from black using the 
	  fade_anim_player.play("FadeIn") function.

	- When transitioning to Level 2, the fade-out effect is triggered to 
	  smoothly move the player to the next scene.

- **Music**:

	- The music for this level is called Game Music Loop 4 and was created by 
	  XtremeFreddy and was found at the following link:
	  https://pixabay.com/sound-effects/game-music-loop-4-144341/

========================================|========================================
								  KNOWN ISSUES
========================================|========================================
- **Save Game Feature**:

	- The save game functionality is currently not working and is commented out 
	  in the script. This feature will need to be implemented in future updates.