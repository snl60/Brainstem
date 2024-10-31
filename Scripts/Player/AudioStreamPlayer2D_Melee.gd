extends AudioStreamPlayer2D


var melee_01 = preload("res://Audio/SFX/Player/Melee/player_melee_01.mp3")
var melee_02 = preload("res://Audio/SFX/Player/Melee/player_melee_02.mp3")
var up_attack = preload("res://Audio/SFX/Player/Melee/player_up_attack.mp3")
var down_attack = preload("res://Audio/SFX/Player/Melee/player_down_attack.mp3")
var jump = preload("res://Audio/SFX/Player/player_jump.mp3")
var jump_double = preload("res://Audio/SFX/Player/player_jump_double.mp3")
var shoot = preload("res://Audio/SFX/Player/player_cannon.mp3")
var slide = preload("res://Audio/SFX/Player/player_slide.mp3")

var current_animation = ""

@onready var player = get_parent()


func _process(delta):
	var new_animation = player.animated_sprite.animation
	if new_animation != current_animation:
		current_animation = new_animation
		play_sound_for_animation(current_animation)


func play_sound_for_animation(animation_name):
	match animation_name:
		"melee_attack_1":
			stream = melee_01
			play()
		"melee_attack_2":
			stream = melee_02
			play()
		"melee_attack_3":
			stream = up_attack
			play()
		"melee_attack_4":
			stream = down_attack
			play()
		"up_attack":
			stream = up_attack
			play()
		"down_attack":
			stream = down_attack
			play()
		"shoot":
			stream = shoot
			play()
		"slide":
			stream = slide
			play()
