extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var idle_timer = $Timer_Idle
@onready var deactivated_timer = $Timer_Deactivated
@onready var pause_input_timer = $Timer_PauseInput
@onready var collision = $Area2D/CollisionShape2D
@onready var player = get_parent().get_node("Player")

var player_in_area = true
var is_deactivated = false


func _ready():
	animated_sprite.play("idle")
	$AudioStreamPlayer2D_HumLoop.play()


func _process(delta):
	if !is_deactivated:
		if $AudioStreamPlayer2D_HumLoop.is_playing() == false:
			$AudioStreamPlayer2D_HumLoop.play()


func _on_animated_sprite_2d_frame_changed():
	match animated_sprite.animation:
		"activate":
			if animated_sprite.frame == 7:
				collision.set_deferred("disabled", false)
		"deactivate":
			if animated_sprite.frame == 1:
				$AudioStreamPlayer2D_HumLoop.stop()
				$AudioStreamPlayer2D_Deactivate.play()
				is_deactivated = true
			if animated_sprite.frame == 6:
				collision.set_deferred("disabled", true)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true
		damage_player()


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false


func damage_player():
	if player.is_dead == false:
		player.is_hit_reacting = true
		player.hit_react()
		player.is_sliding = false
		player.is_input_paused = true
		pause_input_timer.start()
		if player.global_position.x < global_position.x:
			player.velocity.x = -200
			player.velocity.y = -100
		else:
			player.velocity.x = 200
			player.velocity.y = -100
		Global.health -= 25
		HUDManager.update_health(Global.health)


func _on_timer_pause_input_timeout():
	player.is_input_paused = false
	print("Input unpaused")
