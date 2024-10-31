extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var idle_timer = $Timer_Idle
@onready var deactivated_timer = $Timer_Deactivated
@onready var pause_input_timer = $Timer_PauseInput
@onready var collision = $Area2D/CollisionShape2D
@onready var player = get_parent().get_node("Player")

var player_in_area = true


func _ready():
	start_animation_sequence()


func start_animation_sequence():
	animated_sprite.play("activate")


func _on_timer_idle_timeout():
	animated_sprite.play("deactivate")


func _on_timer_deactivated_timeout():
	start_animation_sequence()


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite.animation:
		"activate":
			animated_sprite.play("idle")
			idle_timer.start()
		"deactivate":
			deactivated_timer.start()


func _on_animated_sprite_2d_frame_changed():
	match animated_sprite.animation:
		"activate":
			if animated_sprite.frame == 7:
				collision.set_deferred("disabled", false)
				$AudioStreamPlayer2D_Hum.play()
		"deactivate":
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
		if player.global_position.y < global_position.y:
			player.velocity.x = 0
			player.velocity.y = 100
		else:
			player.velocity.x = 0
			player.velocity.y = -100
		Global.health -= 25
		HUDManager.update_health(Global.health)


func _on_timer_pause_input_timeout():
	player.is_input_paused = false
