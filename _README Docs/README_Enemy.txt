========================================|========================================
                           BRAINSTEM - ENEMY README
========================================|========================================

This is the README document for the Enemy scene/script of the BRAINSTEM game 
prototype project.

========================================|========================================
                                TABLE OF CONTENTS
========================================|========================================
	1. Overview
	2. AI and Movement
	3. Combat Mechanics
	4. Special Behaviors
	5. Known Issues

========================================|========================================
									OVERVIEW
========================================|========================================
The enemies in BRAINSTEM are designed to challenge the player with various 
behaviors and combat mechanics. Each enemy has unique attributes, movement 
patterns, and combat abilities. This document details the functionality of the 
enemies, including their AI, movement, combat mechanics, and interaction with 
the player.

========================================|========================================
                                 AI AND MOVEMENT
========================================|========================================
- **Basic Movement**:

	- Enemies move along a predetermined path, often patrolling an area.

	- The movement direction is managed by the `is_moving_left` variable, which 
	  determines whether the enemy is moving left or right.


- **Turning Around**:

	- Enemies use raycasts and area checks to detect obstacles and ledges. If an 
	  obstacle or ledge is detected, the enemy turns around to avoid it.


- **Stunning and Death**:

	- Enemies can be stunned by the player's attacks, temporarily halting their 
	  movement and attacks.

	- When an enemy's health reaches zero, it triggers a death sequence, 
	  including playing a death animation and disabling collision.

========================================|========================================
								COMBAT MECHANICS
========================================|========================================
- **Detection of Player**:

	- Enemies have detection areas that trigger combat behavior when the player 
	  enters these areas.

	- Detection is managed by the `player_detected` variable, which changes based 
	  on the player's proximity.


- **Attacking**:

	- Enemies attack the player using melee attacks. The attack timing is 
	  controlled by an attack timer, ensuring a rhythm to their attacks.

	- The attack can be interrupted if the enemy is stunned or if the player 
	  moves out of range.


- **Health Management**:

	- Each enemy has a health value that decreases when hit by the player's 
	  attacks.

	- The health is displayed through an on-screen health bar that updates in 
	  real-time as the enemy takes damage.

========================================|========================================
								SPECIAL BEHAVIORS
========================================|========================================
- **Combat Reactions**:

	- Enemies react to being hit by the player, either by turning around, playing
	  a hit animation, or being stunned.

	- Different animations and sound effects are triggered based on the type of 
	  attack (e.g., melee, projectile).


- **AI States**:

	- The enemy AI includes various states such as patrolling, attacking, 
	  stunned, and dead. The state transitions are managed based on the enemy's 
	  interaction with the player and the environment.


- **Collision Management**:

	- Enemies have multiple collision shapes for different parts of their body. 
	  These collisions are enabled or disabled depending on the enemy's current 
	  state or animation frame.

========================================|========================================
								  KNOWN ISSUES
========================================|========================================
- **Save Game Feature**:

	- The save game functionality is currently not working and is commented out 
	  in the script. This feature will need to be implemented in future updates.