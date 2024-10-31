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
	$AnimatedSprite2D.play("idle")


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
