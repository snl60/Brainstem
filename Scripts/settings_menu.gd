extends Control

@onready var master_volume_slider = $CanvasLayer/VFlow_MenuOptions/HSlider_MasterVolume
@onready var music_voume_slider = $CanvasLayer/VFlow_MenuOptions/HSlider_MusicVolume
@onready var sfx_volume_slider = $CanvasLayer/VFlow_MenuOptions/HSlider_SFXVolume
@onready var viewport_size = get_viewport_rect().size
@onready var menu = $CanvasLayer/VFlow_MenuOptions
@onready var title = $CanvasLayer/Label_Title
@onready var sfx_hover = $SfxrStreamPlayer2D_Hover
@onready var sfx_click = $SfxrStreamPlayer2D_Click
@onready var fullscreen_button = $CanvasLayer/VFlow_MenuOptions/Control/Button_ToggleFullscreen
@onready var controls_button = $CanvasLayer/VFlow_MenuOptions/Control/Button_Controls

# Variable to prevent sfx from playing when menu first loads
@onready var initial_load = true

var is_controls_menu_open = false
var previous_scene_name: String

func _ready():
	HUDManager.remove_hud()
	
	$CanvasLayer/VFlow_MenuOptions/HSlider_MasterVolume.grab_focus()
	
	previous_scene_name = Global.scene_name
	Global.scene_name = "settings_menu"
	
	if previous_scene_name == "pause_menu":
		get_parent().get_node("PauseMenu").can_exit = false
	
	menu.position = Vector2(
		viewport_size.x / 2 - menu.size.x / 2,
		175
	)
	
	title.position = Vector2(
		viewport_size.x / 2 - title.size.x / 2,
		60
	)
	
	var initial_master_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	master_volume_slider.value = db_to_linear(initial_master_volume_db) * 100
	
	var initial_music_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	music_voume_slider.value = db_to_linear(initial_music_volume_db) * 100
	
	var initial_sfx_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	sfx_volume_slider.value = db_to_linear(initial_sfx_volume_db) * 100
	
	await get_tree().create_timer(1).timeout
	initial_load = false


func _process(delta):
	exit_to_pause_menu()


## MASTER VOLUME SLIDER
func _on_h_slider_master_volume_value_changed(value):	
	if not initial_load:
		sfx_click.play()
	var db = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)


func _on_h_slider_master_volume_mouse_entered():
	sfx_hover.play()


func _on_h_slider_master_volume_focus_entered():
	if initial_load:
		return
	
	sfx_hover.play()


## MUSIC VOLUME SLIDER
func _on_h_slider_music_volume_value_changed(value):
	if not initial_load:
		sfx_click.play()
	var db = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)


func _on_h_slider_music_volume_mouse_entered():
	sfx_hover.play()


func _on_h_slider_music_volume_focus_entered():
	sfx_hover.play()


## SFX VOLUME SLIDER
func _on_h_slider_sfx_volume_value_changed(value):
	if not initial_load:
		sfx_click.play()
	var db = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)


func _on_h_slider_sfx_volume_mouse_entered():
	sfx_hover.play()


func _on_h_slider_sfx_volume_focus_entered():
	sfx_hover.play()


func linear_to_db(linear):
	return 20 * log(linear)


func db_to_linear(db):
	return pow(10, db / 20.0)


func exit_to_pause_menu():
	if Input.is_action_just_pressed("back"):
		exit_settings_menu()
	elif Input.is_action_just_pressed("slide"):
		if !is_controls_menu_open:
			exit_settings_menu()


## TOGGLE FULLSCREEN BUTTON
func _on_button_toggle_fullscreen_pressed():
	fullscreen_button.disabled = true
	sfx_click.play()
	await sfx_click.finished
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	fullscreen_button.disabled = false


func _on_button_toggle_fullscreen_mouse_entered():
	sfx_hover.play()


func _on_button_toggle_fullscreen_focus_entered():
	sfx_hover.play()


## BACK BUTTON
func _on_button_back_pressed():
	sfx_click.play()
	await sfx_click.finished
	exit_settings_menu()


func _on_button_back_mouse_entered():
	sfx_hover.play()


func _on_button_back_focus_entered():
	sfx_hover.play()


## CONTROLS BUTTON
func _on_button_controls_pressed():
	controls_button.disabled = true
	sfx_click.play()
	await sfx_click.finished
	var controls_scene = preload("res://Scenes/controls.tscn")
	var controls_scene_instance = controls_scene.instantiate()
	add_child(controls_scene_instance)
	controls_button.disabled = false


func _on_button_controls_mouse_entered():
	sfx_hover.play()


func _on_button_controls_focus_entered():
	sfx_hover.play()


func exit_settings_menu():
	Global.scene_name = previous_scene_name
	if previous_scene_name == "pause_menu":
		get_parent().get_node("PauseMenu").get_node("CanvasLayer").get_node("Timer_CanExit").start()
		get_parent().get_node("PauseMenu").get_node("CanvasLayer").get_node("MenuOptions/Control/Resume").grab_focus()
	elif previous_scene_name == "main_menu":
		get_tree().root.get_node("MainMenu/MenuOptions/Control/PlayButton").grab_focus()
	queue_free()
