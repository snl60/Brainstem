extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var idle_timer = $Timer_Idle
@onready var lowered_timer = $Timer_Lowered
@onready var damage_timer = $Timer_Damage
@onready var collision = $Area2D/CollisionShape2D
@onready var player = get_parent().get_node("Player")

var player_in_area = false
var can_damage_player = true


func _ready():
	start_animation_sequence()


func start_animation_sequence():
	animated_sprite.play("activate")


func _on_timer_idle_timeout():
	animated_sprite.play("deactivate")


func _on_timer_lowered_timeout():
	start_animation_sequence()


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite.animation:
		"activate":
			animated_sprite.play("idle")
			idle_timer.start()
		"deactivate":
			lowered_timer.start()


func _on_animated_sprite_2d_frame_changed():
	match animated_sprite.animation:
		"activate":
			if animated_sprite.frame == 7:
				collision.set_deferred("disabled", false)
		"deactivate":
			if animated_sprite.frame == 4:
				collision.set_deferred("disabled", true)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true
		if Global.can_damage_player:
			damage_player()
			Global.can_damage_player = false
			Global.reset_damage()
			damage_timer.start()


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false


func _on_timer_damage_timeout():
	if player_in_area and Global.can_damage_player:
		damage_player()
		Global.can_damage_player = false
		Global.reset_damage()
		damage_timer.start()


func damage_player():
	player.is_hit_reacting = true
	player.hit_react()
	Global.health -= 10
	HUDManager.update_health(Global.health)
