extends Control

@onready var viewport_size = get_viewport_rect().size
@onready var graphics_assets_title = $Label_GraphicsAssets_Title
@onready var graphics_assets_creator = $Label_GraphicAssets_Creator
@onready var graphics_assets_name = $Label_GraphicAssets_Name
@onready var audio_assets_title = $Label_AudioAssets_Title
@onready var audio_assets_creator = $Label_AudioAssets_Creator
@onready var audio_assets_name = $Label_AudioAssets_Name
@onready var credits_title = $Label_Credits
@onready var escape_to_exit = $Label_EscapeToExit
@onready var back_button = $Button_Back
@onready var sfx_hover = $SfxrStreamPlayer2D_Hover
@onready var sfx_click = $SfxrStreamPlayer2D_Click


func _ready():
	Global.scene_name = "credits"
	HUDManager.remove_hud()
	$Button_Back.grab_focus()
	
	credits_title.global_position = Vector2(
		viewport_size.x / 2 - credits_title.size.x / 2,
		25
	)
	
	graphics_assets_title.global_position = Vector2(200, 200)
	graphics_assets_creator.global_position = Vector2(100, 250)
	graphics_assets_name.global_position = Vector2(250, 250)
	
	audio_assets_title.global_position = Vector2(750, 200)
	audio_assets_creator.global_position = Vector2(700, 250)
	audio_assets_name.global_position = Vector2(820, 250)
	
	back_button.global_position = Vector2(
		viewport_size.x / 2 - back_button.size.x / 2,
		viewport_size.y - 100
	)
	escape_to_exit.global_position = Vector2(
		viewport_size.x / 2 - escape_to_exit.size.x / 2,
		viewport_size.y - 50
	)


func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		sfx_click.play()
		await sfx_click.finished
		close_credits()
	
	if Input.is_action_just_pressed("slide"):
		close_credits()

	if Input.is_action_just_pressed("jump"):
		if get_viewport().gui_get_focus_owner() is Button:
			get_viewport().gui_get_focus_owner().emit_signal("pressed")


func close_credits():
	get_parent().close_credits_scene()
	get_parent().get_node("MenuOptions/Control/PlayButton").grab_focus()
	queue_free()


func _on_timer_queue_free_timeout():
	close_credits()


## BACK BUTTON
func _on_button_back_pressed():
	sfx_click.play()
	await sfx_click.finished
	$Timer_QueueFree.start()


func _on_button_back_mouse_entered():
	sfx_hover.play()


func _on_button_back_focus_entered():
	sfx_hover.play()
