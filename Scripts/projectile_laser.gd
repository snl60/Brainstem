extends Area2D

@export var speed: float = 300.0
@export var max_distance: float = 500.0
@export var trail_length: int = 20

@onready var player = get_parent().get_node("Player")
@onready var player_position = player.global_position
@onready var trail = $Line2D_Trail

var velocity = Vector2()
var direction = Vector2()
var start_position = Vector2()
var damage_rating = 5.0


func _ready():
	velocity = direction * speed
	start_position = global_position
	trail.add_point(global_position)


func _process(delta):
	position += velocity * delta
	direction = player_position
	
	$AnimatedSprite2D.play("projectile")
	
	trail.global_position = Vector2(0, 0)
	trail.global_rotation = 0
	
	trail.add_point(global_position)
	if trail.get_point_count() > trail_length:
		trail.remove_point(0)
	
	var distance_travelled = start_position.distance_to(global_position)
	if distance_travelled >= max_distance:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
	elif body.is_in_group("environment"):
		queue_free()


func get_damage_rating():
	return damage_rating
