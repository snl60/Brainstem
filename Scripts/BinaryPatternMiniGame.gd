extends Node2D


@onready var pattern_label = $PatternLabel
@onready var answer_label = $AnswerLabel
@onready var background = $TextureRect_Background
@onready var buttons = [
	$FlowContainer/ChoiceButton1, 
	$FlowContainer/ChoiceButton2, 
	$FlowContainer/ChoiceButton3, 
	$FlowContainer/ChoiceButton4
]
@onready var viewport_size = get_viewport_rect().size

var patterns = []
var correct_answer = ""
var options = []


func _ready():
	#pattern_label.position.x = viewport_size.x / 2 - pattern_label.size.x / 2
	#pattern_label.position.y = viewport_size.y / 4
	
	$FlowContainer.position.x = viewport_size.x / 2 - $FlowContainer.size.x / 2
	$FlowContainer.position.y = viewport_size.y / 1.5 - $FlowContainer.size.y
	
	background.position.x = viewport_size.x / 2 - (background.size.x * 0.75) / 2
	background.position.y = viewport_size.y / 2 - (background.size.y * 0.75) / 2
	
	generate_pattern()
	display_pattern()
	setup_buttons()


func _process(delta):
	pattern_label.position.x = viewport_size.x / 2 - pattern_label.size.x / 2
	pattern_label.position.y = viewport_size.y / 2.5
	
	answer_label.position.x = viewport_size.x / 2 - answer_label.size.x / 2
	answer_label.position.y = viewport_size.y / 2


func generate_pattern():
	patterns = ["0001", "0010", "0100", "1000"]
	var missing_index = randi() % patterns.size()
	correct_answer = patterns[missing_index]
	patterns[missing_index] = "????"
	options = [correct_answer]
	
	while options.size() < buttons.size():
		var option = generate_random_binary()
		if option != correct_answer and option not in options:
			options.append(option)
	
	options.shuffle()


func generate_random_binary():
	var binary = ""
	for i in range(4):
		binary += str(randi() % 2)
	return binary


func display_pattern():
	pattern_label.text = ""
	for pattern in patterns:
		pattern_label.text += pattern + " "


func setup_buttons():
	for i in range(buttons.size()):
		buttons[i].text = options[i]
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(options[i]))


func _on_button_pressed(selected_option):
	if selected_option == correct_answer:
		answer_label.text = "Correct!"
		answer_label.visible = true
	else:
		answer_label.text = "Try Again!"
		answer_label.visible = true
