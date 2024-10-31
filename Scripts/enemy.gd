extends CharacterBody2D

## Local Variables to be initialized on ready when scene loads.
@onready var body_collision = get_node("BodyShape2D")
@onready var animated_sprite = $AnimatedSprite2D
@onready var player_detect_collision = $AreaDetectPlayer.get_node("CollisionShape2D")
@onready var player_node = get_parent().get_node("Player")
@onready var hit_react = $HitReact
@onready var attack_area = $AttackArea
@onready var detect_player_front = $ShapeCast2D_DetectPlayerFront
@onready var detect_player_behind = $ShapeCast2D_DetectPlayerBehind
@onready var area_body_collision = $AreaBody.get_node("CollisionShape2D_Body")
@onready var detect_turn_around_front = $RayCast2D_Forward
@onready var detect_turn_around_down = $RayCast2D_Down
@onready var collision_slash = attack_area.get_node("CollisionShape2D_Slash")
@onready var collision_stab = attack_area.get_node("CollisionShape2D_Stab")

## Local Variables
var SPEED = 80
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_moving_left = true
var is_dead = false
var health = 100
var is_hit = false
var player_detected = false
var is_attacking = false
var attack_timer
var attack_delay = 1.0
var turn_around_timer
var turn_around_delay = 1.0
var is_stunned = false
var damage_rating = 10.0
var death_sound_has_played = false
var can_attack = true

var scene_name = ""
var enemy_id = ""


## READY FUNCTION. Processes when the scene loads.
func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_delay
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	
	turn_around_timer = Timer.new()
	turn_around_timer.wait_time = turn_around_delay
	turn_around_timer.one_shot = true
	add_child(turn_around_timer)
	turn_around_timer.connect("timeout", Callable(self, "_on_turn_around_timer_timeout"))
	
	scene_name = Global.scene_name
	enemy_id = str(global_position)
	if Global.get_enemy_state(scene_name, enemy_id):
		queue_free()


## PHYSICS PROCESS FUNCTION. Processes every frame.
func _physics_process(delta):
	# Handle movement and turn around if enemy is not stunned.
	if !is_stunned:
		move_character(delta)
		detect_turn_around()
	
	# Constantly keep health bar updated
	update_health_bar()
	
	# Detect player
	player_detected = $AreaDetectPlayer.get_overlapping_bodies().size() > 0

	# Check if enemy is dead and handle death event
	if is_dead:
		animated_sprite.play("death")
		$AudioStreamPlayer2D_Attack.stop()
		if !death_sound_has_played:
			$AudioStreamPlayer2D_Death.play()
			death_sound_has_played = true

	# Check enemy health and trigger death event if health <= 0.
	if health <= 0:
		is_dead = true
		call_deferred("set_collision_enabled", body_collision, false)
		call_deferred("set_collision_enabled", player_detect_collision, false)
		call_deferred("set_collision_enabled", area_body_collision, false)
		detect_turn_around_front.set_deferred("enabled", false)
		detect_turn_around_down.set_deferred("enabled", false)
		detect_player_behind.set_deferred("enabled", false)
		detect_player_front.set_deferred("enabled", false)
		Global.save_enemy_state(scene_name, enemy_id, true)

	# Check if player is detected in front of enemy with RayCast2D.
	if detect_player_front.is_colliding():
		$RayCast2D_Forward.set_collision_mask_value(8, false)
	else:
		$RayCast2D_Forward.set_collision_mask_value(8, true)

	# Check which direction enemy is facing to keep health bar fill visual consistent.
	if is_moving_left:
		$HealthBar.fill_mode = ProgressBar.FILL_BEGIN_TO_END
	else:
		$HealthBar.fill_mode = ProgressBar.FILL_END_TO_BEGIN


## MOVEMENT FUNCTIONS
func move_character(delta):
	# Exit function if enemy is dead or if player is detected.
	if is_dead or player_detected:
		return

	# Check for when to attack or move.
	if player_detected and !is_attacking and !is_stunned and can_attack:
		attack()
	elif !player_detected and !is_attacking and !is_stunned:
		velocity.x = SPEED if is_moving_left else -SPEED
		velocity.y += gravity * delta
		animated_sprite.play("run")
		move_and_slide()


## DETECT TURN AROUND FUNCTION
func detect_turn_around():
	if !is_dead:
		if not detect_turn_around_down.is_colliding() and is_on_floor():
			is_moving_left = !is_moving_left
			scale.x = -scale.x
			detect_player_behind.enabled = false
			turn_around_timer.start()
		if detect_turn_around_front.is_colliding() and is_on_floor():
			is_moving_left = !is_moving_left
			scale.x = -scale.x
			detect_player_behind.enabled = false
			turn_around_timer.start()
		if detect_player_behind.is_colliding() and is_on_floor():
			is_moving_left = !is_moving_left
			scale.x = -scale.x
			detect_player_behind.enabled = false
			turn_around_timer.start()


# Function for on timer timeout for turn around timer. Re-enables detect player behind collision area.
func _on_turn_around_timer_timeout():
	detect_player_behind.enabled = true


## COMBAT FUNCTIONS
func _on_area_body_area_entered(area):
	if area.is_in_group("player_sword") and !is_dead: # Hit by player sword
		health -= player_node.attack_rating
		is_hit = true
		if player_node:
			var player_position = player_node.global_position
			if ((is_moving_left and player_position.x < global_position.x) or 
				(!is_moving_left and player_position.x > global_position.x)
			):
				is_moving_left = !is_moving_left
				scale.x = -scale.x
		$HitReact.visible = true
		hit_react.play("hit_react")
		$AudioStreamPlayer2D_Hit.play()
	elif area.is_in_group("player_projectile") and !is_dead: # Hit by player projectile
		health -= 10
		is_stunned = true
		can_attack = false
		if player_node:
			var player_position = player_node.global_position
			if ((is_moving_left and player_position.x < global_position.x) or 
				(!is_moving_left and player_position.x > global_position.x)
			):
				is_moving_left = !is_moving_left
				scale.x = -scale.x
		animated_sprite.play("hit_react_stun")
		$AudioStreamPlayer2D_Attack.stop()
		$SfxrStreamPlayer2D_Stunned.play()
		$Timer_Stun.start()


# Function to reset is_hit variable to false when player sword exits enemy body.
func _on_area_body_area_exited(area):
	if area.is_in_group("player_sword"):
		is_hit = false


# Function for on animated sprite animation finished.
func _on_animated_sprite_2d_animation_finished():
	match animated_sprite.animation:
		"death":
			queue_free()
		"melee_attack_1":
			is_attacking = false
			animated_sprite.play("idle")
			attack_timer.start()


# Function for on hit react animation finished.
func _on_hit_react_animation_finished():
	match $HitReact.animation:
		"hit_react":
			$HitReact.visible = false


# Function for when player is detected in range for melee attack.
func _on_area_detect_player_body_entered(body):
	player_detected = true
	if !is_attacking and !is_stunned and can_attack:
		attack()


# Function to handle attack, called when player is in range.
func attack():
	if not player_node.is_dead and can_attack:
		animated_sprite.play("melee_attack_1")
		is_attacking = true
		$AudioStreamPlayer2D_Attack.play()


# Function to return damage rating for handling damage to player.
func get_damage_rating():
	return damage_rating


# Function to reset player detected variable to false when player goes out of range.
func _on_area_detect_player_body_exited(body):
	if !is_attacking:
		player_detected = false


# Function for when the attack timer times out. Resets is_attacking to false, checks if player in range.
func _on_attack_timer_timeout():
	is_attacking = false
	if player_detected and can_attack:
		attack()
	else:
		move_character(0)


# Function for when the stun timer times out. Resets variables and checks if player in range.
func _on_timer_stun_timeout():
	is_stunned = false
	is_attacking = false
	can_attack = true
	if player_detected:
		attack()
	else:
		move_character(0)


# Function to turn collision on or off during specific frames in attack animation.
func _on_animated_sprite_2d_frame_changed():
	match animated_sprite.animation:
		"melee_attack_1":
			if animated_sprite.frame in [3, 7]:
				call_deferred("set_collision_enabled", collision_slash, true)
				call_deferred("set_collision_enabled", collision_stab, false)
			elif animated_sprite.frame == 10:
				call_deferred("set_collision_enabled", collision_slash, false)
				call_deferred("set_collision_enabled", collision_stab, true)
			else:
				call_deferred("set_collision_enabled", collision_slash, false)
				call_deferred("set_collision_enabled", collision_stab, false)
		_:
			call_deferred("set_collision_enabled", collision_slash, false)
			call_deferred("set_collision_enabled", collision_stab, false)


# Function to set collision as enabled, used in call_deferred lines.
func set_collision_enabled(collision_shape, enabled):
	collision_shape.disabled = not enabled


# Function to update health bar with current health value. Called in _process.
func update_health_bar():
	$HealthBar.value = health


# ##### SAVE GAME ##### ########################################################################## #
# Save game functionality not currently working. Needs to be fixed.
func save():
	# Compile all the data to save in a dictionary
	var save_dict = {
		pos = {
			x = get_position_delta().x,
			y = get_position_delta().y
		},
		health = health
	}
	return save_dict
