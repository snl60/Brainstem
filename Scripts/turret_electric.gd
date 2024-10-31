extends Node2D

@export var projectile_scene: PackedScene
@export var fire_rate: float = 2.0
@export var projectile_speed: float = 300.0

@onready var player = get_parent().get_node("Player")
@onready var fire_position = $Marker2D
@onready var fire_timer = $Timer
@onready var animated_sprite_base = $AnimatedSprite2D_Base
@onready var animated_sprite_hit_react = $AnimatedSprite2D_HitReact

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
	if health <= 0:
		is_destroyed = true
		destroy()
		Global.save_enemy_state(scene_name, enemy_id, true)
	
	if is_destroyed:
		$AudioStreamPlayer2D_ChargeShoot.stop()


func _on_fire_timer_timeout():
	if !is_destroyed:
		animated_sprite_base.play("fire")


func fire_projectile():
	if !is_destroyed:
		var projectile = preload("res://Scenes/projectile_electricity.tscn")
		var projectile_instance = projectile.instantiate()
		var direction = Vector2(-1, 0)
		projectile_instance.position = fire_position.global_position
		get_parent().add_child(projectile_instance)


func _on_animated_sprite_2d_base_frame_changed():
	if animated_sprite_base.animation == "fire":
		if animated_sprite_base.frame == 19:
			fire_projectile()
		elif animated_sprite_base.frame == 10:
			$AudioStreamPlayer2D_ChargeShoot.play()


func _on_area_2d_body_area_entered(area):
	if area.is_in_group("player_sword") and !is_destroyed:
		health -= player.attack_rating
		animated_sprite_hit_react.visible = true
		animated_sprite_hit_react.play("hit_react")
		update_health_bar()
	elif area.is_in_group("player_projectile"):
		health -= 10.0
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
		animated_sprite_base.visible = false
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
				$StaticBody2D_Body.queue_free()
