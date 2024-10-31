extends Node2D

@export var projectile_scene: PackedScene
@export var fire_rate: float = 2.0
@export var projectile_speed: float = 300.0

@onready var fire_position = $Marker2D
@onready var fire_timer = $Timer
@onready var player = get_parent().get_node("Player")
@onready var turret_head = $AnimatedSprite2D_Head
@onready var turret_base = $Sprite2D_Base
@onready var animated_sprite_hit_react = $AnimatedSprite2D_HitReact

var player_in_range = false
var health = 75.0
var is_destroyed = false

var enemy_id = ""
var scene_name = ""


func _ready():
	fire_timer.wait_time = fire_rate
	fire_timer.connect("timeout", Callable(self, "_on_fire_timer_timeout"))
	fire_timer.start()
	
	enemy_id = str(global_position)
	if Global.get_enemy_state(scene_name, enemy_id):
		queue_free()


func _process(delta):
	if player_in_range:
		turret_head.look_at(player.global_position)

	if player.global_position.x < global_position.x:
		turret_head.flip_v = true
	else:
		turret_head.flip_v = false

	if player.is_dead:
		turret_head.rotation = 0
	
	if health <= 0:
		is_destroyed = true
		destroy()
		Global.save_enemy_state(scene_name, enemy_id, true)


func _on_fire_timer_timeout():
	if player_in_range and !player.is_dead and !is_destroyed:
		turret_head.play("fire")
		$AudioStreamPlayer2D_ChargeShoot.play()


func fire_projectile():
	if !is_destroyed:
		var projectile = preload("res://Scenes/projectile_laser.tscn")
		var projectile_instance = projectile.instantiate()
		
		var direction = (player.global_position - fire_position.global_position).normalized()
		
		projectile_instance.direction = direction
		projectile_instance.position = fire_position.global_position
			
		get_parent().add_child(projectile_instance)


func _on_area_2d_range_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		print("Player in range.")


func _on_area_2d_range_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player out of range.")


func _on_animated_sprite_2d_head_frame_changed():
	if turret_head.animation == "fire":
		if turret_head.frame == 10:
			fire_projectile()


func _on_area_2d_body_area_entered(area):
	if area.is_in_group("player_sword") and !is_destroyed:
		health -= player.attack_rating
		animated_sprite_hit_react.visible = true
		animated_sprite_hit_react.play("hit_react")
		update_health_bar()


func _on_animated_sprite_2d_hit_react_animation_finished():
	match animated_sprite_hit_react.animation:
		"hit_react":
			animated_sprite_hit_react.visible = false
		"destroy":
			queue_free()


func update_health_bar():
	$HealthBar.value = health


func destroy():
	if is_destroyed:
		turret_base.visible = false
		turret_head.visible = false
		animated_sprite_hit_react.visible = true
		animated_sprite_hit_react.play("destroy")


func _on_animated_sprite_2d_hit_react_frame_changed():
	match animated_sprite_hit_react.animation:
		"hit_react":
			if animated_sprite_hit_react.frame == 1:
				$SfxrStreamPlayer2D_Hit.play()
		"destroy":
			if animated_sprite_hit_react.frame == 1:
				$SfxrStreamPlayer2D_Hit.play()
			elif animated_sprite_hit_react.frame == 7:
				$SfxrStreamPlayer2D_Destroyed.play()
