extends Node2D

## Local Variables to be loaded on ready
@onready var viewport_size = get_viewport_rect().size
@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var transition_anim_player = $CanvasLayer/ColorRect_SceneTransition/AnimationPlayer
@onready var fade_anim_player = $CanvasLayer/ColorRect_Fade/AnimationPlayer_Fade
@onready var terminal_labels = [
	$Area2D_Terminal_L1Elevator/Label,
	$Area2D_Terminal_Imbuement/Label,
	$Area2D_Terminal_DoubleJump/Label,
	$Area2D_Terminal_Entrance/Label,
	$Area2D_Terminal_Slide/Label,
	$Area2D_Terminal_L3Elevator/Label
]

## Local Variables
# Track when player is at a terminal and which terminal player is at
var player_at_terminal_1 = false # Elevator from Floor 1 to Basement 1
var player_at_terminal_2 = false # Electricity Imbuement gate.
var player_at_terminal_3 = false # Double Jump gate.
var player_at_terminal_4 = false # Level entrance gate.
var player_at_terminal_5 = false # Slide gate.
var player_at_terminal_6 = false # Elevator from Floor 2 to Floor 3.

# Track when player has successfully unlocked a terminal via mini-game. 
# Should make these Global or save to dictionary so they remain persistent when Player transitions between scenes.
var terminal_1_unlocked = false
var terminal_2_unlocked = false
var terminal_3_unlocked = false
var terminal_4_unlocked = false
var terminal_5_unlocked = false
var terminal_6_unlocked = false

# Track when player is at an elevator and which elevator player is at.
var player_at_elevator_1 = false # Elevator from Floor 1 to Basement 1.
var player_at_elevator_2 = false # Elevator from Basement 1 to Floor 1.
var player_at_elevator_3 = false # Elevator from Floor 2 to Floor 3.
var player_at_elevator_4 = false # Elevator from Floor 3 to Floor 2.

# Track whether the opening dialogue has played so it doesn't play twice.
var opening_dialogue_played = false


# Processed when scene is loaded
func _ready():
	print("Level 2 Ready!")
	
	# Set Global variables for tracking what scene player is in.
	Global.current_level = "level_2" # Handles player position when transitioning between scenes.
	Global.scene_name = "level_2"
	
	# Connect input_type signal from global script
	Global.connect("input_type_changed", Callable(self, "_on_input_type_changed"))
	_on_input_type_changed(Global.input_type)
	
	# Fades in from black when scene is loaded.
	transition_fade_in()
	
	# Starts opening dialog timer so the dialogue loads after fade in.
	$Timer_OpeningDialogue.start()


# Processes every frame
func _process(delta):
	# Track what terminal player is at when the Interact action is pressed.
	if Input.is_action_just_pressed("interact"):
		if player_at_terminal_1 and !terminal_1_unlocked:
			binary_terminal_minigame()
		elif player_at_terminal_2 and !terminal_2_unlocked:
			binary_terminal_minigame()
		elif player_at_terminal_3 and !terminal_3_unlocked:
			binary_terminal_minigame()
		elif player_at_terminal_4 and !terminal_4_unlocked:
			binary_terminal_minigame()
		elif player_at_terminal_5 and !terminal_5_unlocked:
			binary_terminal_minigame()
		elif player_at_terminal_6 and !terminal_6_unlocked:
			binary_terminal_minigame()


# Function for when player enters AreaBody2D for door to Level 1. 
# Runs transition_fade_out function and starts transition timer.
func _on_door_to_level_1_body_entered(body):
	if body != player:
		return
	
	transition_fade_out()
	$Timer_FadeOutToLevel1.start()


# Function for when player enters the elevator on Floor 1 that takes player to Basement 1.
func _on_elevator_to_basement_1_body_entered(body):  # player_at_elevator_1
	if body != player or !terminal_1_unlocked:
		return
	
	player_at_elevator_1 = true
	elevator_teleport()


# Function for when player enters the elevator on Basement 1 that takes player to Floor 1.
func _on_elevator_to_floor_1_body_entered(body):  # player_at_elevator_2
	if body != player:
		return
	
	player_at_elevator_2 = true
	elevator_teleport()


# Function for when player picks up the Double Jump upgrade
func _on_double_jump_body_entered(body):
	if body != player:
		return
	
	player.has_double_jump = true
	$AudioStreamPlayer_Pickup.play()
	$Double_Jump/Sprite2D.visible = false
	get_node("Double_Jump").queue_free()
	Dialogic.start("double_jump_timeline")
	dialogue_playing()
	Dialogic.timeline_ended.connect(_on_timeline_ended)


# Function for when player picks up the Electricity Imbuement upgrade.
func _on_electricity_body_entered(body):
	if body != player:
		return
	
	player.has_imbuement_electricity = true
	$AudioStreamPlayer_Pickup.play()
	get_node("Electricity").queue_free()
	Dialogic.start("electricity_imbuement_timeline")
	dialogue_playing()
	Dialogic.timeline_ended.connect(_on_timeline_ended)


# Function for when the player enters the door to the Boos Room.
func _on_boss_room_body_entered(body):
	if body != player:
		return
	
	player.set_physics_process(false)
	player.animated_sprite.play("idle")
	Dialogic.start("boss_room_timeline")
	dialogue_playing()
	Dialogic.timeline_ended.connect(_on_timeline_ended)


# Function for when player picks up the Slide upgrade.
func _on_slide_body_entered(body):
	if body != player:
		return
	
	player.has_slide = true
	$AudioStreamPlayer_Pickup.play()
	get_node("Slide").queue_free()
	Dialogic.start("slide_timeline")
	dialogue_playing()
	Dialogic.timeline_ended.connect(_on_timeline_ended)


# Function for when player picks up the Leg Armor upgrade.
func _on_leg_armor_body_entered(body):
	if body != player:
		return
	
	player.armor += 10.0
	$AudioStreamPlayer_Pickup.play()
	get_node("Leg_Armor").queue_free()
	Dialogic.start("leg_armor_timeline")
	dialogue_playing()
	Dialogic.timeline_ended.connect(_on_timeline_ended)


# Function for when player picks up the Chest Armor upgrade.
func _on_chest_armor_body_entered(body):
	if body != player:
		return
	
	player.armor += 10.0
	$AudioStreamPlayer_Pickup.play()
	get_node("Chest_Armor").queue_free()
	Dialogic.start("chest_armor_timeline")
	dialogue_playing()
	Dialogic.timeline_ended.connect(_on_timeline_ended)


# Function for when player enters the elevator on Floor 2 that takes player to Floor 3.
func _on_elevator_to_floor_3_body_entered(body): # player_at_elevator_3
	if body != player or !terminal_6_unlocked:
		return
	
	player_at_elevator_3 = true
	elevator_teleport()


# Function for when player enters the elevator on Floor 3 that takes player to Floor 2.
func _on_elevator_to_floor_2_body_entered(body): # player_at_elevator_4
	if body != player:
		return
	
	player_at_elevator_4 = true
	elevator_teleport()


# Function for when player is at terminal 1. Terminal for elevator from Floor 1 to Basement 1.
func _on_area_2d_terminal_l_1_elevator_body_entered(body): # player_at_terminal_1
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_1 = true
	if !terminal_1_unlocked:
		$Area2D_Terminal_L1Elevator/Label.visible = true


# Function for when player leaves terminal 1.
func _on_area_2d_terminal_l_1_elevator_body_exited(body): # !player_at_terminal_1
	if !body.is_in_group("Player"):
		return

	player_at_terminal_1 = false
	$Area2D_Terminal_L1Elevator/Label.visible = false


# Function for when player is at terminal 2. Terminal for Electricity Imbuement gate.
func _on_area_2d_terminal_imbuement_body_entered(body): # player_at_terminal_2
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_2 = true
	if !terminal_2_unlocked:
		$Area2D_Terminal_Imbuement/Label.visible = true


# Function for whem player leaves terminal 2.
func _on_area_2d_terminal_imbuement_body_exited(body): # !player_at_terminal_2
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_2 = false
	$Area2D_Terminal_Imbuement/Label.visible = false


# Function for when player is at terminal 3. Terminal for Double Jump gate.
func _on_area_2d_terminal_double_jump_body_entered(body): # player_at_terminal_3
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_3 = true
	if !terminal_3_unlocked:
		$Area2D_Terminal_DoubleJump/Label.visible = true


# Function for when player leaves terminal 3.
func _on_area_2d_terminal_double_jump_body_exited(body): # !player_at_terminal_3
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_3 = false
	$Area2D_Terminal_DoubleJump/Label.visible = false


# Function for when player is at terminal 4. Terminal for level entrance.
func _on_area_2d_terminal_entrance_body_entered(body): # player_at_terminal_4
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_4 = true
	if !terminal_4_unlocked:
		$Area2D_Terminal_Entrance/Label.visible = true


# Function for when player leaves terminal 4.
func _on_area_2d_terminal_entrance_body_exited(body): # !player_at_terminal_4
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_4 = false
	$Area2D_Terminal_Entrance/Label.visible = false


# Function for when player is at terminal 5. Terminal for Slide gate.
func _on_area_2d_terminal_slide_body_entered(body): # player_at_terminal_5
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_5 = true
	if !terminal_5_unlocked:
		$Area2D_Terminal_Slide/Label.visible = true


# Function for when player leaves terminal 5.
func _on_area_2d_terminal_slide_body_exited(body): # !player_at_terminal_5
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_5 = false
	$Area2D_Terminal_Slide/Label.visible = false


# Function for when player is at terminal 6. Terminal for Elevator from Level 2 to Level 3.
func _on_area_2d_terminal_l_3_elevator_body_entered(body): # player_at_terminal_6
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_6 = true
	if !terminal_6_unlocked:
		$Area2D_Terminal_L3Elevator/Label.visible = true


# Function for when player leaves terminal 6.
func _on_area_2d_terminal_l_3_elevator_body_exited(body): # !player_at_terminal_6
	if !body.is_in_group("Player"):
		return
	
	player_at_terminal_6 = false
	$Area2D_Terminal_L3Elevator/Label.visible = false


# Function for Binary Minigame
func binary_terminal_minigame():
	player.is_input_paused = true
	var binary_terminal_scene = preload("res://Scenes/binary_pattern_mini_game(v_2).tscn")
	var binary_terminal_instance = binary_terminal_scene.instantiate()
	$CanvasLayer.add_child(binary_terminal_instance)
	var viewport_size = get_viewport_rect().size
	binary_terminal_instance.position = (
		viewport_size / 2 - binary_terminal_instance.get_viewport_rect().size / 2
	)
	binary_terminal_instance.connect(
		"correct_answer_entered", 
		Callable(self, "_on_correct_answer_entered")
	)


# Function for when correct answer is entered in Binary Minigame. Based on which terminal player is at.
func _on_correct_answer_entered():
	if player_at_terminal_1:
		terminal_1_unlocked = true
	elif player_at_terminal_2:
		terminal_2_unlocked = true
		$Timer_UnlockGate1.start()
	elif player_at_terminal_3:
		terminal_3_unlocked = true
		$Timer_UnlockGate2.start()
	elif player_at_terminal_4:
		terminal_4_unlocked = true
		$Timer_UnlockGateEntrance.start()
	elif player_at_terminal_5:
		terminal_5_unlocked = true
		$Timer_UnlockSlideGate.start()
	elif player_at_terminal_6:
		terminal_6_unlocked = true
		$Area2D_Terminal_L3Elevator/Label.visible = false


# Function for when player enters an unlocked elevator. Pauses movement, plays "idle", fades out, starts timer.
func elevator_teleport():
	player.velocity.x = 0
	player.animated_sprite.play("idle")
	player.is_input_paused = true
	player.is_sliding = false
	transition_anim_player.play("Fade")
	$Timer_Teleport.start()


# Function for when teleport timer times out. Based on which elevator player is at.
func _on_timer_teleport_timeout():
	if player_at_elevator_1:
		player_at_elevator_1 = false
		player.position = Vector2(2450, 2352)
		player.get_node("AnimatedSprite2D").flip_h = true
		player.is_input_paused = false
	elif player_at_elevator_2:
		player_at_elevator_2 = false
		player.position = Vector2(2450, 688)
		player.get_node("AnimatedSprite2D").flip_h = true
		player.is_input_paused = false
	elif player_at_elevator_3:
		player_at_elevator_3 = false
		player.position = Vector2(288, -3352)
		player.is_input_paused = false
	elif player_at_elevator_4:
		player_at_elevator_4 = false
		player.position = Vector2(1096, -784)
		player.get_node("AnimatedSprite2D").flip_h = true
		player.is_input_paused = false


# Function for timer timeout on Gate 1 (Electricity Imbuement gate).
func _on_timer_unlock_gate_1_timeout():
	$Laser_Gate_v5_1.animated_sprite.play("deactivate")


# Function for timer timeout on Gate 2 (Double Jump gate).
func _on_timer_unlock_gate_2_timeout():
	$Laser_Gate_v5_2.animated_sprite.play("deactivate")


# Function for timer timeout on Gate 3 (Level entrance gate).
func _on_timer_unlock_gate_entrance_timeout():
	$Laser_Gate_v5_3.animated_sprite.play("deactivate")


# Function for timer timeout on Gate 4 (Slide gate).
func _on_timer_unlock_slide_gate_timeout():
	$Laser_Gate_v5_4.animated_sprite.play("deactivate")


# Function for fading in from black on scene transition. Pauses input, plays fade in animation, starts timer.
func transition_fade_in():
	$CanvasLayer/ColorRect_Fade.visible = true
	fade_anim_player.play("FadeIn")
	$Timer_FadeIn.start()


# Function for fading out to black on scene transition. Pauses input, plays fade out animation.
func transition_fade_out():
	player.velocity.x = 0
	player.animated_sprite.play("idle")
	player.is_input_paused = true
	player.is_sliding = false
	$CanvasLayer/ColorRect_Fade.visible = true
	fade_anim_player.play("FadeOut")


# Function for on timer timeout for fade in timer.
func _on_timer_fade_in_timeout():
	$CanvasLayer/ColorRect_Fade.visible = false


# Function for on timer timeout for fade out to level 1 scene transition.
func _on_timer_fade_out_to_level_1_timeout():
	var stage = "res://Scenes/level_transition.tscn"
	Global.transition = "level_1"
	get_tree().change_scene_to_file(stage)


# Function for when player picks up health refill before boss room.
func _on_area_2d_health_pickup_body_entered(body):
	if !body.is_in_group("Player"):
		return
	
	Global.minor_health_potion_count = 3
	Global.major_health_potion_count = 3
	Global.greater_health_potion_count = 3
	HUDManager.update_health_potion_count(
		Global.equipped_health_potion_label, 
		Global.get_equipped_health_potion_count()
	)
	$AudioStreamPlayer_Pickup.play()
	$Area2D_HealthPickup.queue_free()


# Function to play the opening dialogue when player loads into level 2 for first time.
func play_opening_dialogue():
	if opening_dialogue_played:
		return
	
	Dialogic.start("level_2_timeline")
	opening_dialogue_played = true
	dialogue_playing()
	Dialogic.timeline_ended.connect(_on_timeline_ended)


# Function for on timer timeout to start playing opening dialogue after scene transition fade in.
func _on_timer_opening_dialogue_timeout():
	play_opening_dialogue()


# Function for Dialogic on timeline end. Reused by each Dialogic timeline that is called.
func _on_timeline_ended():
	player.is_input_paused = false
	player.reset_variables_to_default()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)


func dialogue_playing():
	get_viewport().set_input_as_handled()
	player.pause_input()


func _on_input_type_changed(new_input_type):
	var label_text = ""
	if new_input_type == "keyboard": 
		label_text = "'E'" 
	else: 
		match Global.check_controller_type():
			"xbox":
				label_text = "'X'"
			"playstation":
				label_text = "'Square'"
			"other":
				label_text = "'X/Square'"
	
	for label in terminal_labels:
		label.text = label_text
