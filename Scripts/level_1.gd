extends Node2D

# Local Variables to be loaded on ready
@onready var player = $Player
@onready var fade_anim_player = $CanvasLayer/ColorRect_Fade/AnimationPlayer_Fade


# Processed when scene is loaded
func _ready():
	print("Level 1 Ready!")
	
	# Set Global.scene_name variable to track current scene name for transitioning between levels
	Global.scene_name = "level_1"

	# Handle player location if loading in from level 2
	if Global.current_level == "level_2":
		$Player.position = Vector2(1030, 396)
		$Player.get_node("AnimatedSprite2D").flip_h = true
		Global.current_level = "level_1"
	else:
		Global.current_level = "level_1"

	# Fade in from black when level is loaded
	$CanvasLayer/ColorRect_Fade.visible = true
	fade_anim_player.play("FadeIn")
	await fade_anim_player.animation_finished
	$CanvasLayer/ColorRect_Fade.visible = false

	# Save game feature not currently working
	# Save.save_game()


# Function when entering AreaBody2D for Door to Level 2
func _on_door_to_level_2_body_entered(body):
	if body == player:
		transition_fade_out()


# Function for tansitioning to Level 2, called from body entered function above. Fades out and starts timer.
func transition_fade_out():
	player.velocity.x = 0
	player.animated_sprite.play("idle")
	player.is_input_paused = true
	player.is_sliding = false
	fade_anim_player.play("FadeOut")
	$Timer_Transition.start()


# Timer started from transition fade out function. On timer timeout, transitions player to level 2 scene.
func _on_timer_transition_timeout():
	Global.transition = "level_2"
	Global.scene_name = "level_2"
	get_tree().change_scene_to_file("res://Scenes/level_transition.tscn")
