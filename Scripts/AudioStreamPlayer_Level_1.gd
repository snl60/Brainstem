extends AudioStreamPlayer


var song_loop = preload("res://Audio/Music/Brainstem_Music_Level1 (loop).wav")


func _ready():
	stream = song_loop
	volume_db = -18
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_playing():
		if stream == song_loop:
			stream_paused = false
			if !is_playing():
				play()
