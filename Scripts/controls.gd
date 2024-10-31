extends Control

@onready var viewport_size = get_viewport_rect().size
@onready var controller = $CanvasLayer/TextureRect_Controller
@onready var keyboard = $CanvasLayer/TextureRect_KeyboardMouse
@onready var buttons = $CanvasLayer/VFlowContainer_Buttons
@onready var back_button = $CanvasLayer/Button_Back
@onready var sfx_hover = $SfxrStreamPlayer2D_Hover
@onready var sfx_click = $SfxrStreamPlayer2D_Click


func _ready():
	HUDManager.remove_hud()
	
	$CanvasLayer/VFlowContainer_Buttons/Control/Button_Controller.grab_focus()
	
	get_parent().is_controls_menu_open = true
	
	buttons.position = Vector2(
		viewport_size.x / 2 - buttons.size.x / 2,
		viewport_size.y / 2 - buttons.size.y / 2
	)
	
	controller.position = Vector2(
		viewport_size.x / 2 - controller.size.x / 2,
		viewport_size.y / 2 - controller.size.y / 2
	)
	
	keyboard.position = Vector2(
		viewport_size.x / 2 - keyboard.size.x / 2,
		viewport_size.y / 2 - keyboard.size.y / 2
	)
	
	back_button.position = Vector2(
		viewport_size.x / 2 - back_button.size.x / 2,
		viewport_size.y - 100
	)


func _process(delta):
	if Input.is_action_just_pressed("slide"):
		if controller.visible == true or keyboard.visible == true:
			controller.visible = false
			keyboard.visible = false
			back_button.visible = false
			buttons.visible = true
			$CanvasLayer/VFlowContainer_Buttons/Control/Button_Controller.grab_focus()
		else:
			close_controls_menu()


## CONTROLLER BUTTON
func _on_button_controller_pressed():
	sfx_click.play()
	controller.visible = true
	buttons.visible = false
	back_button.visible = true
	back_button.grab_focus()


func _on_button_controller_mouse_entered():
	sfx_hover.play()


func _on_button_controller_focus_entered():
	sfx_hover.play()


## KEYBOARD/MOUSE BUTTON
func _on_button_keyboard_mouse_pressed():
	sfx_click.play()
	keyboard.visible = true
	buttons.visible = false
	back_button.visible = true
	back_button.grab_focus()


func _on_button_keyboard_mouse_mouse_entered():
	sfx_hover.play()


func _on_button_keyboard_mouse_focus_entered():
	sfx_hover.play()


## BACK BUTTON
func _on_button_back_pressed():
	sfx_click.play()
	keyboard.visible = false
	controller.visible = false
	back_button.visible = false
	buttons.visible = true
	$CanvasLayer/VFlowContainer_Buttons/Control/Button_Controller.grab_focus()


func _on_button_back_mouse_entered():
	sfx_hover.play()


func _on_button_back_focus_entered():
	sfx_hover.play()


## BACK TO SETTINGS BUTTON
func _on_button_back_to_settings_pressed():
	sfx_click.play()
	await sfx_click.finished
	close_controls_menu()


func _on_button_back_to_settings_mouse_entered():
	sfx_hover.play()


func _on_button_back_to_settings_focus_entered():
	sfx_hover.play()


func close_controls_menu():
	get_parent().is_controls_menu_open = false
	get_parent().get_node("CanvasLayer").get_node("VFlow_MenuOptions/HSlider_MasterVolume").grab_focus()
	queue_free()
