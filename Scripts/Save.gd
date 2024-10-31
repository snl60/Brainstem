extends Node

const SAVE_PATH = "res://save.json"
var _settings = {}


func _ready():
	load_game()


func save_game():
	# var save_dict = {}
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var nodes_to_save = get_tree().get_nodes_in_group('persistent')
	for node in nodes_to_save:
		# Check the node is an instanced scene so it can be instanced again during load
		if node.scene_file_path.is_empty():
			print("Persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		# Check the node has a save function
		if !node.has_method("save"):
			print("Persistent node '%s' is missing a save() function, skipped" % node.name)
		
		# Call the node's save function
		var node_data = node.call("save")
		
		# JSON provides a static method to serialized JSON string
		var json_string = JSON.stringify(node_data)
		
		# Store the save dictionary as a new line in the save file
		save_file.store_line(json_string)

	save_file.close()


func load_game():
	# Check for save file to load
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	# Revert game state to avoid cloning objects. Delete savable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		node.queue_free()
	
	# Load the file line by line and process that dictionary to restor the object it represents
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		# Creates the helper class to interact with JSON
		var json = JSON.new()
		
		# Check is there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		# Get the data from the JSON object
		var node_data = json.get_data()
		
		# Create the object and add it to the tree and set its position
		#var new_object = load(node_data["filename"]).instantiate()
		#get_node(node_data["parent"]).add_child(new_object)
		#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		#
		## Set the remaining variables
		#for node in node_data.keys():
			#if node == "filename" or node == "parent" or node == "pos_x" or node == "pos_y":
				#continue
			#new_object.set(node, node_data[node])
