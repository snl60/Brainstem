extends Node2D

@onready var player = $Player
@onready var boss = $Boss_Ember

var boss_in_range = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_level = "boss_room_ember"
	Global.scene_name = "boss_room_ember"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_boss_in_range_body_entered(body):
	if !body.is_in_group("Player") or boss_in_range:
		return
	
	boss_in_range = true
	var camera_zoom_tween = create_tween()
	camera_zoom_tween.tween_property(
		player.get_node("Camera2D"),
		"zoom",
		Vector2(1.5, 1.5),
		2.0
	)
	player.pause_input()
	await get_tree().create_timer(2.5).timeout
	boss.animated_sprite.play("pray_stand")
	await get_tree().create_timer(3.0).timeout
	player.is_input_paused = false
	player.reset_variables_to_default()
	boss.can_attack = true
