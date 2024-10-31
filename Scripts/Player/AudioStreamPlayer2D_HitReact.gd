extends AudioStreamPlayer2D


@onready var player = get_parent()

var hit_sounds = [
	preload("res://Audio/SFX/Player/player_hit_01.mp3"),
	preload("res://Audio/SFX/Player/player_hit_02.mp3"),
	preload("res://Audio/SFX/Player/player_hit_03.mp3")
]

var previous_is_hit_reacting = false

func _ready():
	randomize()


func _process(delta):
	if player.is_hit_reacting and !previous_is_hit_reacting:
		play_random_sound()
	previous_is_hit_reacting = player.is_hit_reacting


func play_random_sound():
	var random_index = randi() % hit_sounds.size()
	var random_sound = hit_sounds[random_index]
	stream = random_sound
	play()
