extends Node2D

# Local Variables to be loaded on ready
@onready var viewport_size = get_viewport_rect().size
@onready var menu = get_node("MenuOptions")
@onready var title = get_node("Title")
@onready var music = $AudioStreamPlayer_Music
@onready var credits_background = $Panel_CreditsBackground
@onready var sfx_hover = $SfxrStreamPlayer2D_Hover
@onready var sfx_click = $SfxrStreamPlayer2D_Click
@onready var sfx_play = $AudioStreamPlayer2D_Play
@onready var play_fade_animation = $ColorRect_Fade/AnimationPlayer_Fade
@onready var fade_color_rect = $ColorRect_Fade
@onready var play_button = $MenuOptions/Control/PlayButton
@onready var load_button = $MenuOptions/Control/LoadGame
@onready var settings_button = $MenuOptions/Control/SettingsButton
@onready var quit_button = $MenuOptions/Control/QuitButton
@onready var credits_button = $CreditsButton

# Variable to prevent sfx from playing when menu first loads
@onready var initial_load = true


# Local Variables
var credits_scene_instance = null
var play_button_pressed = false

# Processed when scene is loaded
func _ready():
	print("MainMenu ready!")
	
	# Sets focus to Play Button when scene loads.
	$MenuOptions/Control/PlayButton.grab_focus()
	
	# Plays main menu music.
	music.play()
	
	# Sets Global.scene_name to "main_menu"
	Global.scene_name = "main_menu"
	
	# Enable all buttons
	enable_all_buttons()
	
	# Reset health and potions when main menu loads.
	Global.health = 100
	Global.minor_health_potion_count = 3
	Global.major_health_potion_count = 3
	Global.greater_health_potion_count = 3

	# Position the title in center of viewport
	$Title.global_position = Vector2(
		viewport_size.x / 2 - title.size.x / 2,
		viewport_size.y / 5 - title.size.y / 2
	)

	# Position the menu in center of viewport
	$MenuOptions.global_position = Vector2(
		viewport_size.x / 2 - menu.size.x / 2,
		viewport_size.y / 1.65 - menu.size.y / 2
	)

	# Position the credits button on bottom right of viewport
	$CreditsButton.global_position = Vector2(
		viewport_size.x - $CreditsButton.size.x - 10,
		viewport_size.y - $CreditsButton.size.y - 10
	)

	# Access global HUDManager to run remove_hud() function to remove HUD from viewport in main menu
	HUDManager.remove_hud()
	
	# Checks if the platform is not PC and hides Quit button.
	# Needs to be changed to handle hiding the Toggle Fullscreen button from Setting menu instead.
	if !OS.has_feature("pc"):
		# $MenuOptions/FullscreenButton.hide()
		$MenuOptions/QuitButton.hide()
	
	# Set Global current level to '0'
	Global.current_level = "main_menu"


# Processes every frame.
func _process(delta):
	if Input.is_action_just_pressed("open_credits"):
		load_credits_screen()


## PLAY BUTTON
# Function to handle when Play button is pressed.
func _on_play_pressed():
	disable_all_buttons()
	if !play_button_pressed:
		sfx_play.play()
		play_button_pressed = true
	fade_color_rect.visible = true
	play_fade_animation.play("Fade")
	await get_tree().create_timer(2.0).timeout
	Global.current_level = "level_1"
	Global.scene_name = "level_1"
	Global.transition = "level_1"
	get_tree().change_scene_to_file("res://Scenes/level_transition.tscn")


# Function to play sfx when mouse enters play button
func _on_play_button_mouse_entered():
	if initial_load:
		initial_load = false
		return
	
	sfx_hover.play()


# Function to play sfx when play button focus entered
func _on_play_button_focus_entered():
	if initial_load:
		initial_load = false
		return
	
	sfx_hover.play()


## SETTINGS BUTTON
# Function to handle when Settings button is pressed.
func _on_settings_button_pressed():
	disable_all_buttons()
	sfx_click.play()
	await sfx_click.finished
	initial_load = true
	open_settings_menu()


func _on_settings_button_mouse_entered():
	sfx_hover.play()


func _on_settings_button_focus_entered():
	sfx_hover.play()


## QUIT BUTTON
# Function to handle when Quit button is pressed.
func _on_quit_pressed():
	disable_all_buttons()
	sfx_click.play()
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()


func _on_quit_button_mouse_entered():
	sfx_hover.play()


func _on_quit_button_focus_entered():
	sfx_hover.play()


## LOAD BUTTON
# Function to handle when Load Game button is pressed.
func _on_load_game_pressed():
	disable_all_buttons()
	sfx_click.play()
	Save.load_game()


func _on_load_game_mouse_entered():
	sfx_hover.play()


func _on_load_game_focus_entered():
	sfx_hover.play()


## CREDITS BUTTON
# Function to handle when Credits button is pressed.
func _on_credits_button_pressed():
	disable_all_buttons()
	sfx_click.play()
	load_credits_screen()


# Function to load the credits screen when button or F3 is pressed.
func load_credits_screen():
	if credits_scene_instance == null:
		var credits_scene = preload("res://Scenes/credits.tscn")
		credits_scene_instance = credits_scene.instantiate()
		credits_background.visible = true
		add_child(credits_scene_instance)


# Function to close out of credits screen.
func close_credits_scene():
	if credits_scene_instance != null:
		credits_scene_instance.queue_free()
		credits_scene_instance = null
	credits_background.visible = false
	enable_all_buttons()


# Function to play main menu music on a loop after a short timer.
func _on_timer_music_timeout():
	music.play()


# Function that starts the music timer when the menu music finishes.
func _on_audio_stream_player_music_finished():
	$Timer_Music.start()


# Function that handles opening the settings menu.
func open_settings_menu():
	var settings_scene = preload("res://Scenes/settings_menu.tscn")
	var settings_scene_instance = settings_scene.instantiate()
	get_parent().add_child(settings_scene_instance)
	enable_all_buttons()


func enable_all_buttons():
	play_button.disabled = false
	load_button.disabled = false
	settings_button.disabled = false
	quit_button.disabled = false
	credits_button.disabled = false


func disable_all_buttons():
	play_button.disabled = true
	load_button.disabled = true
	settings_button.disabled = true
	quit_button.disabled = true
	credits_button.disabled = true
