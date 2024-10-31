========================================|========================================
                                    BRAINSTEM
							   MAIN PROJECT README
========================================|========================================

Welcome to BRAINSTEM, a 2D side-scrolling action-adventure game set in a 
dystopian future where AI controls most of humanity through neural implants. 
Take on the role of Eli "Beacon" Ryder, a cybernetically enhanced protagonist, 
and fight to restore freedom to humanity.

========================================|========================================
                                TABLE OF CONTENTS
========================================|========================================
	1. Overview
	2. Getting Started
	3. Controls
	4. Story
	5. Gameplay Mechanics
	6. Project Structure
	7. Credits and Attributions

========================================|========================================
                                    OVERVIEW
========================================|========================================
BRAINSTEM is a sci-fi action-adventure game where players navigate a cyberpunk 
world filled with high-tech labs, decaying urban landscapes, and fortified AI 
installations. Using a mix of melee and ranged combat, players must solve 
puzzles, hack systems, and defeat formidable AI-controlled enemies to progress 
through the game.

========================================|========================================
								 GETTING STARTED
========================================|========================================
Once the project is open in Godot, you can start the game by clicking the Play 
button or pressing F5. The game will launch in a new window where you can begin 
your mission to defeat the AI overlords.

**Game Objective**
Your mission is to navigate through the cyberpunk world, using your neural 
device, sword, and arm-cannon to overcome obstacles, solve puzzles, and 
ultimately destroy the AI's central computer.

========================================|========================================
									CONTROLS
========================================|========================================
Action               | Key/Mouse      | Controller (Xbox/PS)
---------------------|----------------|--------------------------
Move Left/Right      | W/D            | Left Thumbstick or D-Pad
Jump                 | Space          | A/X
Melee Attack         | Left Click     | Right Trigger
Upward Attack        | D + Left Click | Up + Right Trigger
Downward Attack      | S + Left Click | Down + Right Trigger
Shoot                | Right Click    | Left Trigger
Interact             | E              | X/Square
Switch Imbuement     | 1              | LB/L1
Switch Health Potion | 2              | RB/R1
Use Health Potion    | Q              | Y/Triangle
Pause/Resume         | Escape         | Start

========================================|========================================
									  STORY
========================================|========================================
BRAINSTEM is set in a future where AI has taken control of humanity through 
neural implants. As Eli "Beacon" Ryder, you are awakened from a coma by Dr. 
Thaddeus Maddison, the very scientist who inadvertently enabled the AI's control. 
Equipped with cutting-edge cybernetic enhancements and a new neural device immune 
to AI hacking, you must journey through various hostile environments to dismantle 
the AI overlords and restore humanity's freedom.

========================================|========================================
							   GAMEPLAY MECHANICS
========================================|========================================
- **Exploration**: Traverse interconnected 2D levels, uncover secrets, and solve 
				   environmental puzzles.

- **Combat**: Engage in melee and ranged combat, utilizing weapon imbuements like 
			  Plasma, Electricity, and Nano-Tech to exploit enemy weaknesses.

- **Hacking**: Use your neural device to hack systems, disable traps, and unlock 
			   new areas.

- **Puzzle-Solving**: Overcome complex puzzles that require strategic use of your
				      abilities and upgrades.

- **Boss Fights**: Face off against powerful AI bosses, each with unique 
				   mechanics and vulnerabilities.

========================================|========================================
							    PROJECT STRUCTURE
========================================|========================================
The project is organized as follows:

- **Scenes/**: Contains all the game scenes, such as levels, menus, and HUD.

- **Scripts/**: Holds all GDScript files that control game logic, player 
				behavior, and enemy AI.

- **Assets/**: Includes sprites, textures, sounds, and other media assets.

- **Global.gd**: A singleton script for managing global variables and game 
				 states.

- **HUDManager.gd**: A singleton script that manages keeping the player's HUD 
					 updated.

- **Player.gd**: Handles all the player functionality, including movement, 
				 attacking, and character progression.

- **Enemy.gd**: Handles the functionality for the single enemy character that 
				currently exists in the game. Additional enemies to be added at 
				a later date, which may alter the structure.

- **Level_X.gd**: Each level or scene has its own script that handles all the 
				  specific functionality for that level/scene.

- **Additional Scripts**: There are inidependent scripts for various aspects of 
						  the game, including but not limited to Main_Menu.gd, 
						  Turret_[TYPE].gd, and Laser_[WALL/GATE].gd.

========================================|========================================
							 CREDITS AND ATTRIBUTIONS
========================================|========================================
BRAINSTEM was developed by Scott Lopez using many free assets found online, 
typically on either itch.io or pixabay.com. Scott Lopez also composed the music 
for Level 2.

Attributions:

Creator			 | Asset Name		
URL
-----------------|------------------------------------------------------------
Anokolisa		 | Sidescroller Shooter - Central City https://anokolisa.itch.io/sidescroller-shooter-central-city
-----------------|------------------------------------------------------------
Anokolisa		 | Free Action Pack - City
https://anokolisa.itch.io/action
-----------------|------------------------------------------------------------
FoozleCC		 | Sci-Fi Lab - Tileset / Decor / Traps
https://foozlecc.itch.io/sci-fi-lab-tileset-decor-traps
-----------------|------------------------------------------------------------
Shade	         | Free 16x16 Assorted RPG Icons
https://merchant-shade.itch.io/16x16-mixed-rpg-icons
-----------------|------------------------------------------------------------
Free Game Assets | Free Industrial Zone Tileset
https://free-game-assets.itch.io/free-industrial-zone-tileset-pixel-art
-----------------|------------------------------------------------------------
KBPixelArt		 | Main Character of the Story
https://kbpixelart.itch.io/main-character-of-the-story
-----------------|------------------------------------------------------------
Szadi art		 | 2D SL Knight
https://szadiart.itch.io/2d-soulslike-character
-----------------|------------------------------------------------------------
Wenrexa			 | Assets Free Interface US Kit #4
https://wenrexa.itch.io/ui-different02
-----------------|------------------------------------------------------------
JeltsinSH		 | Ambient Game (music)
https://pixabay.com/sound-effects/ambient-game-67014/
-----------------|------------------------------------------------------------
XtremeFreddy	 | Game Music Loop 4
https://pixabay.com/sound-effects/game-music-loop-4-144341/
-----------------|------------------------------------------------------------
plasterbrain	 | Game Start
https://pixabay.com/sound-effects/game-start-6104/
-----------------|------------------------------------------------------------
drummy			 | bottle_open
https://pixabay.com/sound-effects/bottle-open-99732/
-----------------|------------------------------------------------------------
Time_Verberne	 | Sci-Fi Weapon Charging 01
https://pixabay.com/sound-effects/sci-fi-weapon-charging-01-96645/
-----------------|------------------------------------------------------------
Kinoton			 | Short Whoosh, 13x
https://pixabay.com/sound-effects/short-whoosh-13x-14526/
-----------------|------------------------------------------------------------
666HeroHero		 | Slash
https://pixabay.com/sound-effects/slash-21834/
-----------------|------------------------------------------------------------
Amber2023		 | Grunts
https://pixabay.com/sound-effects/grunts-127455/
-----------------|------------------------------------------------------------
Hidiku			 | Boy Pack 1
https://pixabay.com/sound-effects/boy-pack-1-24920/
-----------------|------------------------------------------------------------
pixabay			 | 962708_Laser Charging
https://pixabay.com/sound-effects/062708-laser-charging-81968/
-----------------|------------------------------------------------------------
Muhammad Ali	 | Gaming pc icon
https://www.flaticon.com/free-icons/gaming-pc
-----------------|------------------------------------------------------------
SieuAmThanh		 | Beam 8
https://pixabay.com/sound-effects/beam-8-43831/
-----------------|------------------------------------------------------------
pixabay			 | unfa's Laser Weapon Sounds
https://pixabay.com/sound-effects/028747-unfa39s-laser-weapon-sounds-75877/
-----------------|------------------------------------------------------------