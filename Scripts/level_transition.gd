extends Node2D

@onready var fade_in_anim_player = $CanvasLayer/ColorRect_FadeIn/AnimationPlayer_FadeIn

func _ready():
	Global.scene_name = "level_transition"
	$CanvasLayer/Control.PRESET_CENTER
	fade_in_anim_player.play("FadeIn")
	HUDManager.remove_hud()
	$Timer.start()


func _on_timer_timeout():
	match Global.transition:
		"level_1":
			get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
		"level_2":
			get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
