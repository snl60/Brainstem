extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var is_moving_left = false
var can_attack = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	animated_sprite.play("pray_idle")


func _physics_process(delta):
	if !can_attack:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "pray_stand":
		animated_sprite.play("idle")
		await get_tree().create_timer(1.0).timeout
		scale.x = -scale.x
		is_moving_left = !is_moving_left
