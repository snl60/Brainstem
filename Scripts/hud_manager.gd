extends CanvasLayer

var hud
var main_menu_scene_name = "MainMenu"

func _ready():
	_initialize_hud()


func _initialize_hud():
	var current_scene_name = get_tree().current_scene.name
	print("Current scene name: " + current_scene_name)
	
	if current_scene_name == main_menu_scene_name:
		remove_hud()
		return # Early return if current scene is main menu.
	
	if hud:
		return # Early return if HUD already displayed.
	
	var hud_scene = ResourceLoader.load("res://Scenes/hud.tscn")
	
	if !hud_scene:
		print("Failed to load Healthbar scene.")
		return # Early return if HUD scene fails to load.
	
	print("HUD loaded successfully.")
	
	if not hud_scene is PackedScene:
		print("Loaded resource is not a PackedScene.")
		return # Early return if HUD scene is not a packed scene.
	
	# Instance the HUD scene
	hud = hud_scene.instantiate()
	add_child(hud)
	print("HUD added to the scene.")


func update_health(value):
	if not hud:
		print("HUD instance is not available")
		return
	
	hud.update_health(value)


func update_health_potion_count(equipped_health_potion, count):
	if not hud:
		print("HUD instance is not available")
		return # Early return if HUD not loaded.
	
	hud.update_health_potion_count(equipped_health_potion, count)


func update_health_potion_icon(icon_texture):
	if not hud:
		print("HUD instance not available")
		return # Early return if HUD not loaded.
	
	hud.update_health_potion_icon(icon_texture)


func update_can_shoot_progress(max_time, current_time):
	if not hud:
		print("HUD instance not available")
		return # Early return if HUD not loaded.
	
	hud.update_can_shoot_progress(max_time, current_time)


func update_weapon_type(type):
	if not hud:
		print("HUD instance not available")
		return # Early return if HUD not loaded.
	
	hud.update_weapon_type(type)


func set_imbuement_visible(visible):
	if not hud:
		print("HUD instance not available")
		return # Early return if HUD not loaded.
	
	hud.set_imbuement_visible(visible)


func remove_hud():
	if not hud:
		print("No HUD to remove.")
		return # Early return if HUD not loaded.
	
	hud.queue_free()
	hud = null
	print("HUD removed.")
