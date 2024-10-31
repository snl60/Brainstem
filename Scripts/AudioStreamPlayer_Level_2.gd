extends AudioStreamPlayer

var song_intro = preload("res://Audio/Music/Brainstem_Music (intro).wav")
var song_loop = preload("res://Audio/Music/Brainstem_Music (loop).wav")


func _ready():
	stream = song_intro
	volume_db = -12
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_playing():
		if stream == song_intro:
			stream = song_loop
			volume_db = -12
			play()
			stream_paused = false
		elif stream == song_loop:
			stream_paused = false
			if !is_playing():
				play()
