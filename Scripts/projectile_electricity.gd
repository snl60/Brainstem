extends Area2D

@onready var player = get_parent().get_node("Player")

@export var speed: float = 300.0
@export var max_distance: float = 500.0

var velocity = Vector2()
var start_position = Vector2()
var damage_rating = 10.0


func _ready():
	var direction = Vector2(-1, 0)
	velocity = direction * speed
	start_position = global_position


func _process(delta):
	position += velocity * delta
	
	if !player.is_dead:
		$AnimatedSprite2D.play("projectile")
	
	var distance_travelled = start_position.distance_to(global_position)
	if distance_travelled >= max_distance:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player") and !player.is_sliding:
		queue_free()
	elif body.is_in_group("environment"):
		queue_free()


func get_damage_rating():
	return damage_rating
