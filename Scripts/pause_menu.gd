extends Control

@onready var viewport_size = get_viewport_rect().size
@onready var menu = $CanvasLayer/MenuOptions
@onready var player = get_parent().get_parent().get_node("Player")
@onready var sfx_hover = $SfxrStreamPlayer2D_Hover
@onready var sfx_click = $SfxrStreamPlayer2D_Click

var previous_scene_name: String
var can_exit = false

func _ready():
	HUDManager.remove_hud()
	
	if Global.scene_name != "main_menu":
		get_tree().paused = true
	
	player.is_input_paused = true
	
	Global.is_game_paused = true
	
	Dialogic
	
	$CanvasLayer/MenuOptions/Control/Resume.grab_focus()
	
	$CanvasLayer/Timer_CanExit.start()
	
	if Global.scene_name != "settings_menu":
		previous_scene_name = Global.scene_name
	Global.scene_name = "pause_menu"
	
	menu.position = Vector2(
		viewport_size.x / 2 - menu.size.x / 2,
		viewport_size.y / 2 - menu.size.y / 2
	)


func _process(delta):
	if can_exit: 
		if Input.is_action_just_pressed("back"):
			exit_pause_menu()
	
	if Input.is_action_just_pressed("jump"):
		if get_viewport().gui_get_focus_owner() is Button:
			get_viewport().gui_get_focus_owner().emit_signal("pressed")


## RESUME BUTTON
func _on_resume_pressed():
	sfx_click.play()
	await sfx_click.finished
	exit_pause_menu()


func _on_resume_mouse_entered():
	sfx_hover.play()


func _on_resume_focus_entered():
	sfx_hover.play()


## MAIN MENU BUTTON
func _on_main_menu_button_pressed():
	sfx_click.play()
	await sfx_click.finished
	Global.scene_name = "main_menu"
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	queue_free()


func _on_main_menu_button_mouse_entered():
	sfx_hover.play()


func _on_main_menu_button_focus_entered():
	sfx_hover.play()


## SETTINGS BUTTON
func _on_settings_button_pressed():
	sfx_click.play()
	await sfx_click.finished
	var settings_scene = preload("res://Scenes/settings_menu.tscn")
	var settings_instance = settings_scene.instantiate()
	get_parent().get_parent().get_node("CanvasLayer").add_child(settings_instance)


func _on_settings_button_mouse_entered():
	sfx_hover.play()


func _on_settings_button_focus_entered():
	sfx_hover.play()


## QUIT BUTTON
func _on_quit_button_pressed():
	sfx_click.play()
	await sfx_click.finished
	get_tree().quit()


func _on_quit_button_mouse_entered():
	sfx_hover.play()


func _on_quit_button_focus_entered():
	sfx_hover.play()


func exit_pause_menu():
	get_tree().paused = false
	player.is_input_paused = false
	Global.is_game_paused = false
	HUDManager._initialize_hud()
	Global.scene_name = previous_scene_name
	if previous_scene_name == "main_menu":
		get_tree().current_scene.get_node("MenuOptions/Control/PlayButton").grab_focus()
	queue_free()


func _on_timer_can_exit_timeout():
	can_exit = true
