extends Node

var current_level: String
var difficulty_rating = 1.0

var health = 100
var max_health = 100
var can_damage_player = true

var minor_health_potion_count = 3
var major_health_potion_count = 3
var greater_health_potion_count = 3

var weapon_type = false
var weapon_texture: Texture

var equipped_health_potion_type = 0 # 0 = Minor, 1 = Major, 2 = Greater
var equipped_health_potion_label: String
var equipped_health_potion_icon: Texture

var enemy_states = {}
var scene_name = ""
var transition = ""

var is_game_paused = false
var input_type = "controller"

signal input_type_changed(new_input_type)


func _ready():
	update_equipped_health_potion_label()
	update_weapon_type_texture()
	var cursor_bullseye = preload("res://GUI/Cursor_Bullseye(48x48).png")
	Input.set_custom_mouse_cursor(cursor_bullseye, 0, Vector2(24, 24))


func _process(delta):
	if Input.is_action_just_pressed("jump"):
		if get_viewport().gui_get_focus_owner() is Button:
			get_viewport().gui_get_focus_owner().emit_signal("pressed")


# Function that maintains the correct equipped health potion label
func update_equipped_health_potion_label():
	match equipped_health_potion_type:
		0:
			equipped_health_potion_label = "Minor"
		1:
			equipped_health_potion_label = "Major"
		2:
			equipped_health_potion_label = "Greater"
	HUDManager.update_health_potion_count(equipped_health_potion_label, get_equipped_health_potion_count())


# Function that maintains the correct health potion type
func update_equipped_health_potion_icon():
	match equipped_health_potion_type:
		0:
			equipped_health_potion_icon = preload("res://Icons/Health/minor_health_potion.png")
		1:
			equipped_health_potion_icon = preload("res://Icons/Health/major_health_potion.png")
		2:
			equipped_health_potion_icon = preload("res://Icons/Health/greater_health_potion.png")


# Function that keeps health potion count updated
func get_equipped_health_potion_count():
	match equipped_health_potion_type:
		0:
			return minor_health_potion_count
		1:
			return major_health_potion_count
		2:
			return greater_health_potion_count
		_:
			return 0


# Function that tracks the enemies dead/alive status
func save_enemy_state(scene_name, enemy_id, is_dead):
	if not enemy_states.has(scene_name):
		enemy_states[scene_name] = {}
	enemy_states[scene_name][enemy_id] = is_dead


# Function to return the status of the enemies to keep alive state persistent
func get_enemy_state(scene_name, enemy_id):
	if enemy_states.has(scene_name) and enemy_states[scene_name].has(enemy_id):
		return enemy_states[scene_name][enemy_id]
	return false


# Functiion to change the weapon icon to match the equipped weapon type
func update_weapon_type_texture():
	if weapon_type:
		weapon_texture = preload("res://Icons/sword_electric.png")
	else:
		weapon_texture = preload("res://Icons/sword_regular.png")


# Function to display the imbuement icon in the HUD
func update_imbuement_state(imbuement_enabled):
	if imbuement_enabled:
		HUDManager.set_imbuement_visible(true)
	else:
		HUDManager.set_imbuement_visible(false)


# Function to allow player to be damaged by obstacles in world
func reset_damage():
	await get_tree().create_timer(0.5).timeout
	can_damage_player = true


# ##### Handle Input Events ######################################################## #
func _input(event):
	# Track input type
	var new_input_type = input_type
	
	# Press 'back' (Esc or B/Circle) to open the pause menu
	if event.is_action_pressed("back"):
		var scene_name_list = [
			"main_menu",
			"settings_menu",
			"pause_menu",
			"level_transition",
			"credits"
		]
		if not scene_name in scene_name_list:
			open_pause_menu()
	# Using a controller changes 'input_type' to "controller" and hides the mouse cursor
	elif (event is InputEventJoypadMotion or event is InputEventJoypadButton) and input_type != "controller":
		input_type = "controller"
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		emit_signal("input_type_changed", input_type)
		print("Controller is being used.")
	# Using keyboard/mouse changes 'input_type' to "keyboard" and shows the mouse cursor
	elif (event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion) and input_type != "keyboard":
		input_type = "keyboard"
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		emit_signal("input_type_changed", input_type)
		print("Keyboard is being used.")


func open_pause_menu():
	var current_scene = get_tree().current_scene
	var canvas_layer = current_scene.get_node("CanvasLayer")
	var pause_menu_scene = preload("res://Scenes/pause_menu.tscn")
	var pause_menu_instance = pause_menu_scene.instantiate()
	canvas_layer.add_child(pause_menu_instance)


func check_controller_type():
	var device_id = 0
	if Input.is_joy_known(device_id):
		var controller_name = Input.get_joy_name(device_id)
		print("Detected controller name:", controller_name)
		
		if "Xbox" in controller_name or "XInput" in controller_name:
			print("Xbox controller detected")
			return "xbox"
		elif (
			"Wireless Controller" in controller_name or
			"DualShock" in controller_name or 
			"DualSense" in controller_name
		):
			print("Playstation controller detected")
			return "playstation"
		else:
			print("Other controller type detected")
			return "other"
	else:
		print("No known controller type detected")
		return "none"
