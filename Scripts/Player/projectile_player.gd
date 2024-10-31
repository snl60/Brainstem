extends Area2D

@export var speed: float = 400.0
@export var max_distance: float = 500.0

var velocity = Vector2()
var direction = Vector2.RIGHT
var start_position = Vector2()


func _ready():
	velocity = direction * speed
	start_position = global_position


func _process(delta):
	# Move the projectile
	position += velocity * delta
	
	# Play animation and flip horizontally if necessary
	$AnimatedSprite2D.play("projectile")
	if get_parent().get_node("Player").animated_sprite.flip_h == true:
		$AnimatedSprite2D.flip_h = true
	
	# Remove projectile after it reaches max distance
	var distance_travelled = start_position.distance_to(global_position)
	if distance_travelled >= max_distance:
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("environment"):
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("environment"):
		queue_free()

