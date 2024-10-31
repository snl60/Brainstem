========================================|========================================
                           BRAINSTEM - PLAYER README
========================================|========================================

This is the README document for the Player scene/script of the BRAINSTEM game 
prototype project.

========================================|========================================
                                TABLE OF CONTENTS
========================================|========================================
	1. Overview
	2. Movement and Physics
	3. Combat Mechanics
	4. Special Abilities
	5. Health and Potions
	6. Collision and Interaction
	7. Known Issues

========================================|========================================
									OVERVIEW
========================================|========================================
The player character, Eli "Beacon" Ryder, is a cybernetically enhanced 
protagonist equipped with various combat abilities and movement techniques. This 
document details the player character's functionality, including movement, combat 
mechanics, health management, and special abilities.

========================================|========================================
                              MOVEMENT AND PHSYICS
========================================|========================================
- **Basic Movement**:

	- The player can move left or right using the assigned controls. Movement 
	  speed is adjusted based on the player's actions (e.g., sliding, attacking).

  
- **Jumping**:

	- The player can perform a basic jump and a double jump if the Double Jump 
	  upgrade is acquired.

	- The jump's height and velocity are controlled by the `jump_velocity` 
	  variable.


- **Sliding and Dodging**:

	- Sliding allows the player to quickly move horizontally while reducing 
	  collision with certain obstacles.

	- Dodging is used to evade attacks when stationary.


- **Gravity**:

	- Gravity is applied consistently to ensure realistic movement and falling. 
	  The gravity value is synced with the project settings.

========================================|========================================
								COMBAT MECHANICS
========================================|========================================
- **Melee Attacks**:

	- The player can perform a series of melee attacks, forming a combo if 
	  executed within a specific time frame.

	- The combo system is reset if the player does not chain attacks quickly 
	  enough.


- **Shooting**:

	- The arm-cannon allows the player to shoot projectiles. There is a cooldown 
	  period between shots, managed by a timer.

	- The projectile's direction is determined by the player's facing direction.


- **Imbuements**:

	- The player can imbue their weapons with special abilities like Electricity, 
	  enhancing attack power and changing the visual effects.


- **Health Management**:

	- The player has a health bar, and the current health is managed by the 
	  `Global.health` variable.

	- Health can be restored using health potions of varying potency (Minor, 
	  Major, Greater).

========================================|========================================
								SPECIAL ABILITIES
========================================|========================================
- **Double Jump**:

	- Allows the player to perform a second jump while in the air, enabling 
	  access to higher areas.


- **Slide**:

	- A quick horizontal movement that reduces the player's collision box, 
	  useful for evading attacks or moving through narrow spaces.


- **Electricity Imbuement**:

	- Enhances the player's attack power by imbuing their weapons with electrical 
	  energy. This ability can be toggled on or off.

========================================|========================================
								HEALTH AND POTIONS
========================================|========================================
- **Health Potions**:

	- The player can carry and use different types of health potions:

		- **Minor Health Potion**: Restores 25 health points.

		- **Major Health Potion**: Restores 50 health points.

		- **Greater Health Potion**: Restores 100 health points.

	- Potions can be cycled through and used during gameplay via assigned 
	  controls.


- **Armor**:

	- Armor provides additional protection, reducing the damage taken from 
	  enemies. Armor values can be increased through upgrades.

========================================|========================================
							COLLISION AND INTERACTIONS
========================================|========================================
- **Collision Masks**:

	- Collision masks are dynamically updated based on the player's actions 
	  (e.g., sliding reduces the collision mask).

	- The player can phase through certain objects when sliding, allowing for 
	  advanced movement techniques.


- **Environmental Interactions**:

	- The player interacts with the environment through various actions, such 
	  as hacking terminals, activating switches, and picking up items.

========================================|========================================
								  KNOWN ISSUES
========================================|========================================
- **Save Game Feature**:

	- The save game functionality is currently not working and is commented out 
	  in the script. This feature will need to be implemented in future updates.
