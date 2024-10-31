extends Node2D

@onready var pattern_label = $Label_Pattern
@onready var answer_label = $Label_Answer
@onready var instructions_label = $Label_Instructions
@onready var spin_boxes = [
	$HBoxContainer/SpinBox1,
	$HBoxContainer/SpinBox2,
	$HBoxContainer/SpinBox3,
	$HBoxContainer/SpinBox4
]
@onready var submit_button = $Button_Submit
@onready var viewport_size = get_viewport_rect().size
@onready var background = $TextureRect_Background
@onready var player = get_parent().get_parent().get_node("Player")

var patterns = []
var correct_answer = ""
var current_focus_index = 0
var is_unlocked = false
var is_correct_answer = false

signal correct_answer_entered

func _ready():
	background.position.x = viewport_size.x / 2 - (background.size.x * 0.75) / 2
	background.position.y = viewport_size.y / 2 - (background.size.y * 0.75) / 2
	
	instructions_label.position.x = viewport_size.x / 2 - instructions_label.size.x / 2
	instructions_label.position.y = viewport_size.y / 3
	
	pattern_label.position.x = viewport_size.x / 2 - pattern_label.size.x / 2
	pattern_label.position.y = viewport_size.y / 2.5
	
	answer_label.position.x = viewport_size.x / 2 - answer_label.size.x / 2
	answer_label.position.y = viewport_size.y / 2
	
	$HBoxContainer.position.x = viewport_size.x / 2 - $HBoxContainer.size.x / 2
	$HBoxContainer.position.y = viewport_size.y / 1.75
	
	submit_button.position.x = viewport_size.x / 2 - submit_button.size.x / 2
	submit_button.position.y = viewport_size.y / 1.5
	
	generate_pattern()
	display_pattern()
	submit_button.connect("pressed", Callable(self, "_on_submit_button_pressed"))
	
	for spin_box in spin_boxes:
		spin_box.min_value = 0
		spin_box.max_value = 1
		spin_box.step = 1
		spin_box.focus_mode = Control.FOCUS_ALL
	
	submit_button.focus_mode = Control.FOCUS_ALL
	
	spin_boxes[current_focus_index].grab_focus()


func _process(delta):
	if current_focus_index == 0:
		$HBoxContainer/SpinBox1/TextureRect1.visible = true
	else:
		$HBoxContainer/SpinBox1/TextureRect1.visible = false
	
	if current_focus_index == 1:
		$HBoxContainer/SpinBox2/TextureRect2.visible = true
	else:
		$HBoxContainer/SpinBox2/TextureRect2.visible = false
	
	if current_focus_index == 2:
		$HBoxContainer/SpinBox3/TextureRect3.visible = true
	else:
		$HBoxContainer/SpinBox3/TextureRect3.visible = false
	
	if current_focus_index == 3:
		$HBoxContainer/SpinBox4/TextureRect4.visible = true
	else:
		$HBoxContainer/SpinBox4/TextureRect4.visible = false


func generate_pattern():
	patterns = ["0001", "0010", "0100", "1000"]
	var missing_index = randi() % patterns.size()
	correct_answer = patterns[missing_index]
	patterns[missing_index] = "????"


func display_pattern():
	pattern_label.text = ""
	for pattern in patterns:
		pattern_label.text += pattern + " "


func _on_submit_button_pressed():
	var player_answer = ""
	for spin_box in spin_boxes:
		player_answer += str(spin_box.value)
	
	if player_answer == correct_answer:
		answer_label.text = "Correct!"
		is_unlocked = true
		emit_signal("correct_answer_entered")
		if !is_correct_answer:
			is_correct_answer = true
			$Timer_QueueFree.start()
	else:
		answer_label.text = "Try Again!"


func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		if current_focus_index < 4:
			spin_boxes[current_focus_index].value = 1
	elif Input.is_action_just_pressed("ui_down"):
		if current_focus_index < 4:
			spin_boxes[current_focus_index].value = 0
	elif Input.is_action_just_pressed("ui_right"):
		if current_focus_index < spin_boxes.size():
			current_focus_index += 1
			if current_focus_index < 4:
				spin_boxes[current_focus_index].grab_focus()
			elif current_focus_index == 4:
				submit_button.grab_focus()
	elif Input.is_action_just_pressed("ui_left"):
		if current_focus_index > 0:
			current_focus_index -= 1
			spin_boxes[current_focus_index].grab_focus()


func _on_timer_queue_free_timeout():
	player.is_input_paused = false
	queue_free()
