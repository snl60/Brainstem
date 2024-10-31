extends CharacterBody2D

## Local Variables to be called on ready when the scene loads.
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var slide_trail = $GPUParticles2D_Slide
@onready var dodge_trail = $GPUParticles2D_Dodge
@onready var jump_trail = $GPUParticles2D_Jump

## Local Variables
# ##### MOVEMENT VARIABLES ##### ################################################################# #
var speed = 200.0
var jump_velocity = -350.0
var facing_right = true
var on_floor = true
var jump_count = 0
var is_jumping = false
var is_double_jumping = false
var is_falling = false
var is_sliding = false
var is_dodging = false
var has_double_jump = false
var has_slide = false

# ##### FALL DAMAGE VARIABLES ##### ############################################################## #
var fall_start_y = 0.0
var fall_damage_threshold = 200
var damage_per_unit = 0.1

# ##### COMBAT VARIABLES ##### ################################################################### #
const combo_timeout = 1.0
var combo_timer = 0.0
var is_attacking = false
var is_shooting = false
var can_shoot = true
var attack_step = 0
var attack_queued = false
var base_attack_rating = 25.0
var attack_rating = base_attack_rating
var armor = 0.0
var armor_rating = 0.0

var is_hit = false
var is_hit_reacting = false

var is_dead = false
var death_animation_played = false

var electricity = false
var has_imbuement_electricity = false

# ##### HEALTH POTIONS VARIABLES ##### ########################################################### #
var minor_health_potion = 25
var major_health_potion = 50
var greater_health_potion = 100

# ##### CACHING COLLISION BOXES ##### ############################################################ #
var collision_right
var collision_right_up
var collision_right_down

var collision_left
var collision_left_up
var collision_left_down

var collision_standing
var collision_sliding

var original_collision_mask

# ##### GET THE GRAVITY FROM THE PROJECT SETTINGS TO BE SYNCED WITH RIGIDBODY NODES. ##### ####### #
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# ##### PAUSE INPUT VARIABLES ##### ############################################################## #
var is_paused = false
var is_input_paused = false


## ############################################################################################## ##
##                                       READY FUNCTION                                           ##
## ############################################################################################## ##
# Processes when player loads into the scene.
func _ready():
	animated_sprite.connect("frame_changed", Callable(self, "_on_frame_changed"))
	initialize_collision_shapes()
	initialize_hud()


# Function to initialize the collision shapes.
func initialize_collision_shapes():
	collision_right = attack_area.get_node("CollisionShape2DRight")
	collision_right_up = attack_area.get_node("CollisionShape2DRightUp")
	collision_right_down = attack_area.get_node("CollisionShape2DRightDown")
	collision_left = attack_area.get_node("CollisionShape2DLeft")
	collision_left_up = attack_area.get_node("CollisionShape2DLeftUp")
	collision_left_down = attack_area.get_node("CollisionShape2DLeftDown")
	collision_standing = $CollisionShape_Standing
	collision_sliding = $CollisionShape_Sliding
	original_collision_mask = collision_mask
	floor_snap_length = 5.5


# Function that initialized player's HUD. Calls from global HUDManager script.
func initialize_hud():
	HUDManager._initialize_hud()
	update_equipped_health_potion(0)


## ############################################################################################## ##
##                                   PROCESS(DELTA) FUNCTION                                      ##
## ############################################################################################## ##
# Processes every frame. Movement, combat, player inputs all handled herein.
func _physics_process(delta):
	if is_paused:
		return
	
	if is_dead:
		return
	
	# Functions to be processes every frame
	update_combat_timer(delta)
	check_player_health()
	update_player_speed()
	update_collision_masks()
	apply_gravity(delta)
	handle_jump()
	handle_movement()
	handle_actions()
	handle_fall_damage()
	update_slide_trail()
	update_dodge_trail()
	update_jump_trail()
	update_can_shoot_progress()
	check_imbuement()


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #### ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


## ############################################################################################## ##
##                                           FUNCTIONS                                            ##
## ############################################################################################## ##
# Function to handle the melee combinations. 
# Player must press melee input before melee timer times out to trigger combo.
func update_combat_timer(delta):
	if combo_timer > 0:
		combo_timer -= delta
	else:
		attack_step = 0
		attack_queued = false


# Function that checks player's health to see if player has died.
func check_player_health():
	if Global.health <= 0:
		is_dead = true
	if is_dead:
		death()
		return


# Function that updates player's speed depending actions player is taking.
func update_player_speed():
	if is_attacking:
		speed = 100
	elif is_sliding:
		speed = 400
	elif is_shooting:
		if is_on_floor():
			speed = 0
	else:
		speed = 200


# Function that updates collision masks based on whether player is sliding.
# Allows player to phase through enemies.
func update_collision_masks():
	if is_sliding:
		collision_mask &= ~2
		collision_mask &= ~1
		$AreaBody.collision_mask &= ~2
		$AreaBody.collision_mask &= ~1
		collision_standing.disabled = true
		collision_sliding.disabled = false
	else:
		collision_mask = original_collision_mask
		$AreaBody.collision_mask = original_collision_mask
		collision_standing.disabled = false
		collision_sliding.disabled = true


# Function that applies gravity based on ProjectSettings (gravity var).
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		on_floor = false


# Function that handles jump and double jump. Jump input tracked herein.
func handle_jump():
	if is_dead:
		return
	
	if Input.is_action_just_pressed("jump") and !is_input_paused:
		if is_sliding:
			is_sliding = false # Cancels out slide and prevents multiple animations fighting for priority
			jump_count += 1
			velocity.y = jump_velocity
			$AudioStreamPlayer2D_Actions.stream = preload("res://Audio/SFX/Player/player_jump.mp3")
			$AudioStreamPlayer2D_Actions.play()
			if !is_shooting:
				animated_sprite.play("jump_start")
		elif jump_count < 1 and !is_attacking and !has_double_jump:
			is_jumping = true
			jump_count += 1
			velocity.y = jump_velocity
			$AudioStreamPlayer2D_Actions.stream = preload("res://Audio/SFX/Player/player_jump.mp3")
			$AudioStreamPlayer2D_Actions.play()
			if !is_shooting:
				animated_sprite.play("jump_start")
		elif jump_count < 2 and !is_attacking and has_double_jump:
			is_jumping = true
			if jump_count > 0:
				is_double_jumping = true
			if is_double_jumping and is_shooting:
				return
			jump_count += 1
			velocity.y = jump_velocity
			if is_double_jumping:
				$AudioStreamPlayer2D_Actions.stream = $AudioStreamPlayer2D_Actions.jump_double
				$AudioStreamPlayer2D_Actions.play()
			else:
				$AudioStreamPlayer2D_Actions.stream = $AudioStreamPlayer2D_Actions.jump
				$AudioStreamPlayer2D_Actions.play()
			if !is_shooting:
				animated_sprite.play("jump_start")
			$Timer_DoubleJump.start()
	
	if jump_count == 1: # Checks jump count and determines jump velocity. Jump velocity is lowered for double jump.
		jump_velocity = -250
	else:
		jump_velocity = -350
	
	if velocity.y == 0: # Resets jump count when player y velocity is 0, meaning player is on floor.
		jump_count = 0
		is_jumping = false
		on_floor = true
	else:
		on_floor = false
	
	if not is_on_floor() and !is_attacking and !is_jumping and !is_shooting: # Switches to falling animation.
		animated_sprite.play("falling")
		on_floor = false


# Function to handle player movement
func handle_movement():
	if is_dead:
		return
	
	move_and_slide() # Godot standard library function for movement handling type.
	
	if !is_input_paused: # Movement only allowed if is_input_paused == false.
		var direction = Input.get_axis("move_left", "move_right")
		
		if direction and !is_sliding:
			velocity.x = direction * speed
			facing_right = direction > 0
			if !is_attacking and !is_jumping and !is_sliding and !is_shooting and is_on_floor():
				animated_sprite.play("run")
			update_flip_direction()
		else:
			if is_sliding:
				update_slide_direction()
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
				is_sliding = false
			if !is_attacking and !is_jumping and !is_sliding and !is_shooting and is_on_floor():
				animated_sprite.play("idle")
		
		if not is_on_floor():
			is_sliding = false
		
		if is_shooting and is_on_floor():
				velocity.x = 0.0


# Function to flip player sprite depending on which direction (left or right) the player is facing.
func update_flip_direction():
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0:
		animated_sprite.flip_h = true
		$HitReact.flip_h = true
		$Death.flip_h = true
		$Death.position = Vector2(24, 0)
	else:
		animated_sprite.flip_h = false
		$HitReact.flip_h = false
		$Death.flip_h = false


# Function to check which direction the player is facing to determine slide velocity. 
# Slide velocity is a set speed and direction and cannot be altered by input.
func update_slide_direction():
	if facing_right:
		velocity.x = speed
	else:
		velocity.x = -speed


## ############################################################################################## ##
##                                   HANDLE ACTIONS FUNCTION                                      ##
## ############################################################################################## ##
# Function that handles most input actions, with the exception of jump, move left/right, and interact.
func handle_actions():
	if is_dead or is_input_paused:
		return
	
	# Move left or right
	var direction = Input.get_axis("move_left", "move_right")
	
	# Melee attack. Checks if ui_up or ui_down is pressed.
	if (
		Input.is_action_just_pressed("melee_attack") and
		not Input.is_action_pressed("ui_up") and
		not Input.is_action_pressed("ui_down")
	):
		start_attack()
	
	# Up attack. Triggers if ui_up is pressed.
	if Input.is_action_pressed("ui_up") and Input.is_action_just_pressed("melee_attack"):
		up_attack()
	
	# Down attack. Triggers if ui_down is pressed.
	if Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("melee_attack"):
		down_attack()
	
	# Shoot arm cannon.
	if Input.is_action_just_pressed("shoot"):
		if !is_shooting and can_shoot:
			shoot()
	
	# Slide or dodge backwards, depending on if player moving left, right, or standing still.
	if Input.is_action_just_pressed("slide"):
		if (
			!is_attacking and 
			!is_shooting and 
			is_on_floor() and 
			Input.get_axis("move_left", "move_right") and 
			has_slide
		):
			is_sliding = true
			animated_sprite.play("slide")
		elif (
			!is_attacking and 
			!is_shooting and 
			is_on_floor() and 
			not Input.get_axis("move_left", "move_right")
		):
			is_dodging = true
			$AudioStreamPlayer2D_Actions.stream = preload("res://Audio/SFX/Player/player_jump_double.mp3")
			$AudioStreamPlayer2D_Actions.play()
			if facing_right:
				direction = 1
				velocity.x = -direction * speed * 5
				velocity.y = -100
				$Timer_Dodge.start()
			else:
				direction = -1
				velocity.x = -direction * speed * 5
				velocity.y = -100
				$Timer_Dodge.start()
	
	# Switch imbuement.
	if (
		Input.is_action_just_pressed("Imbuement") and 
		!is_attacking and 
		!is_jumping and 
		!is_sliding and 
		on_floor and 
		has_imbuement_electricity
	):
		$SfxrStreamPlayer_SwitchImbuement.play()
		if electricity == true:
			electricity = false
			attack_rating = base_attack_rating
			$AnimatedSprite2D_Electricity.animation = $AnimatedSprite2D.animation
			if $AnimatedSprite2D_Electricity.flip_h == true:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			Global.weapon_type = false
			Global.update_weapon_type_texture()
			HUDManager.update_weapon_type(Global.weapon_texture)
			HUDManager.set_imbuement_visible(false)
			print("Attack Rating: " + str(attack_rating))
		else:
			electricity = true
			attack_rating = base_attack_rating * 1.5
			$AnimatedSprite2D_Electricity.animation = $AnimatedSprite2D.animation
			if $AnimatedSprite2D.flip_h == true:
				$AnimatedSprite2D_Electricity.flip_h = true
			else: 
				$AnimatedSprite2D_Electricity.flip_h = false
			Global.weapon_type = true
			Global.update_weapon_type_texture()
			HUDManager.update_weapon_type(Global.weapon_texture)
			HUDManager.set_imbuement_visible(true)
			print("Attack Rating: " + str(attack_rating))
	
	# Change health potion.
	if Input.is_action_just_pressed("change_health_potion"):
		update_equipped_health_potion(1)
		$SfxrStreamPlayer_SwitchPotion.play()
	
	# Use health potion.
	if Input.is_action_just_pressed("use_health_potion"):
		use_health_potion()


# Checks to see which imbuement is equipped, if any. Each Imbuement uses a unique AnimatedSprite2D.
func check_imbuement():
	if is_dead:
		return
	
	if electricity == true: # Electricity Imbuement.
		animated_sprite = $AnimatedSprite2D_Electricity
		$AnimatedSprite2D_Electricity.visible = true
		$AnimatedSprite2D.visible = false
		if not animated_sprite.is_connected(
			"animation_finished", 
			Callable(self, "_on_animated_sprite_2d_animation_finished")
		):
			animated_sprite.connect(
				"animation_finished", 
				Callable(self, "_on_animated_sprite_2d_animation_finished")
			)
		if not animated_sprite.is_connected("frame_changed", Callable(self, "_on_frame_changed")):
			animated_sprite.connect("frame_changed", Callable(self, "_on_frame_changed"))
	else: # No Imbuement.
		animated_sprite = $AnimatedSprite2D
		$AnimatedSprite2D_Electricity.visible = false
		$AnimatedSprite2D.visible = true
		if not animated_sprite.is_connected(
			"animation_finished", 
			Callable(self, "_on_animated_sprite_2d_animation_finished")
		):
			animated_sprite.connect(
				"animation_finished", 
				Callable(self, "_on_animated_sprite_2d_animation_finished")
			)
		if not animated_sprite.is_connected("frame_changed", Callable(self, "_on_frame_changed")):
			animated_sprite.connect("frame_changed", Callable(self, "_on_frame_changed"))


# Function to handle fall damage when player falls from a height higher than the threshold.
func handle_fall_damage():
	if not is_on_floor():
		if !is_falling:
			is_falling = true
			fall_start_y = global_position.y
	else:
		if is_falling:
			var fall_distance = fall_start_y - global_position.y
			if fall_distance < -fall_damage_threshold:
				apply_fall_damage(-fall_distance)
			is_falling = false


# Function to flip slide trail depending on which way the player is sliding.
func update_slide_trail():
	if animated_sprite.flip_h == true:
		slide_trail.texture = load("res://Main_Character/MainChar - slide (frame left).png")
	else:
		slide_trail.texture = load("res://Main_Character/MainChar - slide (frame right).png")

	slide_trail.emitting = is_sliding


# Function to flide the dodge trail depending on which way the player is facing.
func update_dodge_trail():
	if animated_sprite.flip_h == true:
		dodge_trail.texture = load("res://Main_Character/Anims/MainChar - dodge back left.png")
	else:
		dodge_trail.texture = load("res://Main_Character/Anims/MainChar - dodge back right.png")
	
	dodge_trail.emitting = is_dodging


# Function to reset is_dodging to false when dodge timer times out.
func _on_dodge_timer_timeout():
	is_dodging = false


# Function to add jump trail when player uses 2nd jump in double jump. Changes depending on which way player is facing.
func update_jump_trail():
	if animated_sprite.flip_h == true:
		jump_trail.texture = load("res://Main_Character/Anims/MainChar - dodge back left.png")
	else:
		jump_trail.texture = load("res://Main_Character/Anims/MainChar - dodge back right.png")
	
	if is_double_jumping and !is_shooting:
		jump_trail.emitting = true
	else:
		jump_trail.emitting = false


# Function to reset is_double_jumping to false after double jump timer times out.
func _on_double_jump_timer_timeout():
	is_double_jumping = false


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #### ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


## ############################################################################################## ##
##                                        COMBAT FUNCTIONS                                        ##
## ############################################################################################## ##
# Function that starts melee attack and checks if player is on floor.
# If player is in air, player performs up attack by default.
func start_attack():
	if is_on_floor():
		if !is_attacking and !is_sliding and !is_shooting:
			perform_attack()
		elif combo_timer > 0 and attack_step < 3:
			attack_queued = true
			combo_timer = combo_timeout
	else:
		up_attack()


# Function that performs melee attack combo.
func perform_attack():
	if attack_step == 0:
		animated_sprite.play("melee_attack_1")
	elif attack_step == 1:
		animated_sprite.play("melee_attack_2")
	elif attack_step == 2:
		animated_sprite.play("melee_attack_3")
	elif attack_step == 3:
		animated_sprite.play("melee_attack_4")
	
	is_attacking = true
	combo_timer = combo_timeout


# Function that handles upward attack.
func up_attack():
	if !is_attacking and !is_sliding:
		animated_sprite.play("up_attack")
		is_attacking = true
		combo_timer = combo_timeout


# Function that handles downward attack.
func down_attack():
	if !is_attacking and !is_sliding:
		animated_sprite.play("down_attack")
		is_attacking = true
		combo_timer = combo_timeout


# Function that handles shooting arm cannon.
func shoot():
	if !is_attacking and !is_sliding:
		can_shoot = false
		is_shooting = true
		animated_sprite.play("shoot")
		$Timer_SpawnProjectile.start()


# Function that updates arm cannon progress bar after shooting arm cannon.
func update_can_shoot_progress():
	if not $Timer_CanShoot.is_stopped():
		HUDManager.update_can_shoot_progress($Timer_CanShoot.wait_time, $Timer_CanShoot.time_left)


# Function that spawn projectile when player shoot arm cannon.
func spawn_projectile():
	if is_shooting:
		var projectile = preload("res://Scenes/Player/projectile_player.tscn")
		var projectile_instance = projectile.instantiate()
		
		$Timer_CanShoot.start()
		
		if animated_sprite.flip_h == true:
			projectile_instance.direction = Vector2.LEFT
			projectile_instance.position = position + Vector2(-30, -10)
		else:
			projectile_instance.direction = Vector2.RIGHT
			projectile_instance.position = position + Vector2(30, -10)
		get_parent().add_child(projectile_instance)


# Function that spawns the projectile when the spawn projectile timer times out.
func _on_timer_spawn_projectile_timeout():
	if is_shooting:
		spawn_projectile()
		is_shooting = false


# Function that resets can_shoot to true when can shoot timer times out.
func _on_timer_can_shoot_timeout():
	can_shoot = true


# Function that handles when player is hit by enemy sword or turret projectile.
# Damage taken is determined by enemy/turret damage_rating() function.
func _on_area_body_area_entered(area):
	if is_dead:
		return
	
	var damage_sources = ["enemy_sword", "turret_projectile"]
	for group in damage_sources:
		if area.is_in_group(group):
			var parent_node = area.get_parent()
			if parent_node.has_method("get_damage_rating"):
				var damage = parent_node.get_damage_rating()
				armor_rating = 1.0 - (armor / 100.0)
				var damage_taken = damage * armor_rating
				print("Damage Taken: ", damage_taken)
				is_hit_reacting = true
				hit_react()
				Global.health -= damage_taken
				is_hit = true
				update_health_bar()
			else:
				print("Parent node does not have 'damage_rating': ", parent_node)


# Function to handle player hit reaction when hit by enemies/projectiles.
func hit_react():
	if is_hit_reacting and !is_dead and !is_sliding:
		$HitReact.play("hit_react")
		$HitReact.visible = true
		$AudioStreamPlayer2D_HitReact.play()
	else:
		$HitReact.visible = false


# Function to handle when enemy swords or turret projectiles leave player's body. Resets is_hit to false.
func _on_area_body_area_exited(area):
	var damage_sources = ["enemy_sword", "turret_projectile"]
	for group in damage_sources:
		if area.is_in_group(group):
			is_hit = false


# Function to update health bar with current health. 
# Calls function from HUDManager and uses Global.health to track player's health.
func update_health_bar():
	HUDManager.update_health(Global.health)


# Function to handle death event.
func death():
	if death_animation_played:
		return
	
	animated_sprite.set_deferred("visible", false) # animated_sprite.visible = false
	$Death.visible = true
	$Death.play("death")
	death_animation_played = true


# Function to handle make HitReact AnimatedSprite2D invisible after hit react finishes.
func _on_hit_react_animation_finished():
	if $HitReact.animation == "hit_react":
		is_hit_reacting = false
		$HitReact.visible = false


## ############################################################################################## ##
##                                    ON ANIMATION FINISHED                                       ##
## ############################################################################################## ##
# Function to handle what happens when animations are finished.
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation in [
		"melee_attack_1", 
		"melee_attack_2", 
		"melee_attack_3", 
		"melee_attack_4", 
		"up_attack", 
		"down_attack"
	]:
		is_attacking = false
		is_shooting = false
		if attack_queued:
			attack_step += 1
			attack_queued = false
			perform_attack()
		else:
			attack_step = 0
	elif animated_sprite.animation == "shoot":
		is_attacking = false
		is_shooting = false
	elif animated_sprite.animation == "slide":
		speed = 200
		is_sliding = false
	elif animated_sprite.animation == "jump_start":
		is_jumping = false


## ############################################################################################## ##
##                                    ON FRAME CHANGED FUNCTION                                   ##
## ############################################################################################## ##
# Function to handle turning collisions on an off depending on frame of attack animations.
func _on_frame_changed():
	match animated_sprite.animation:
		"melee_attack_1":
			if not animated_sprite.flip_h:
				if animated_sprite.frame == 6:
					call_deferred("set_collision", collision_right, false)
				else:
					call_deferred("set_collision", collision_right, true)
			else:
				if animated_sprite.frame == 6:
					call_deferred("set_collision", collision_left, false)
				else:
					call_deferred("set_collision", collision_left, true)
		"melee_attack_2":
			if not animated_sprite.flip_h:
				if animated_sprite.frame in range(3, 4):
					call_deferred("set_collision", collision_right, false)
				else:
					call_deferred("set_collision", collision_right, true)
			else:
				if animated_sprite.frame in range(3, 4):
					call_deferred("set_collision", collision_left, false)
				else:
					call_deferred("set_collision", collision_left, true)
		"melee_attack_3":
			if not animated_sprite.flip_h:
				if animated_sprite.frame == 2:
					call_deferred("set_collision", collision_right, false)
					call_deferred("set_collision", collision_right_up, false)
				else:
					call_deferred("set_collision", collision_right, true)
					call_deferred("set_collision", collision_right_up, true)
			else:
				if animated_sprite.frame == 2:
					call_deferred("set_collision", collision_left, false)
					call_deferred("set_collision", collision_left_up, false)
				else:
					call_deferred("set_collision", collision_left, true)
					call_deferred("set_collision", collision_left_up, true)
		"melee_attack_4":
			if not animated_sprite.flip_h:
				if animated_sprite.frame in range(2, 4):
					call_deferred("set_collision", collision_right_down, false)
				else:
					call_deferred("set_collision", collision_right_down, true)
			else:
				if animated_sprite.frame in range(4, 6):
					call_deferred("set_collision", collision_left_down, false)
				else:
					call_deferred("set_collision", collision_left_down, true)
		"down_attack":
			if not animated_sprite.flip_h:
				if animated_sprite.frame in range(4, 6):
					call_deferred("set_collision", collision_right_down, false)
				else:
					call_deferred("set_collision", collision_right_down, true)
			else:
				if animated_sprite.frame in range(4, 6):
					call_deferred("set_collision", collision_left_down, false)
				else:
					call_deferred("set_collision", collision_left_down, true)
		"up_attack":
			if not animated_sprite.flip_h:
				if animated_sprite.frame == 2:
					call_deferred("set_collision", collision_right, false)
					call_deferred("set_collision", collision_right_up, false)
				else:
					call_deferred("set_collision", collision_right, true)
					call_deferred("set_collision", collision_right_up, true)
			else:
				if animated_sprite.frame == 2:
					call_deferred("set_collision", collision_left, false)
					call_deferred("set_collision", collision_left_up, false)
				else:
					call_deferred("set_collision", collision_left, true)
					call_deferred("set_collision", collision_left_up, true)
		_:
			call_deferred("set_collision", collision_right, true)
			call_deferred("set_collision", collision_right_up, true)
			call_deferred("set_collision", collision_right_down, true)
			call_deferred("set_collision", collision_left, true)
			call_deferred("set_collision", collision_left_up, true)
			call_deferred("set_collision", collision_left_down, true)


# Function to set collision shapes to disabled, used in call_deferred.
func set_collision(collision_shape, disabled):
	collision_shape.disabled = disabled


## ############################################################################################## ##
##                                     HEALTH POTION FUNCTIONS                                    ##
## ############################################################################################## ##
# Update equipped potion icon, count, and label. Calls Global and HUDManager scripts.
func update_equipped_health_potion(amount):
	Global.equipped_health_potion_type = (Global.equipped_health_potion_type + amount) % 3
	Global.update_equipped_health_potion_label()
	Global.update_equipped_health_potion_icon()
	HUDManager.update_health_potion_count(
		Global.equipped_health_potion_label, 
		Global.get_equipped_health_potion_count()
	)
	HUDManager.update_health_potion_icon(Global.equipped_health_potion_icon)


# Function to handle using a health potion. Call Global and HUDManager scripts.
func use_health_potion():
	if Global.health >= Global.max_health:
		return
	
	var heal_amount = 0
	
	match Global.equipped_health_potion_type:
		0:
			if Global.minor_health_potion_count <= 0:
				$SfxrStreamPlayer_EmptyPotion.play()
				return
			
			heal_amount = minor_health_potion
			$AudioStreamPlayer_HealthPotion.play()
			Global.minor_health_potion_count -= 1
		1:
			if Global.major_health_potion_count <= 0:
				$SfxrStreamPlayer_EmptyPotion.play()
				return
			
			heal_amount = major_health_potion
			$AudioStreamPlayer_HealthPotion.play()
			Global.major_health_potion_count -= 1
		2:
			if Global.greater_health_potion_count <= 0:
				$SfxrStreamPlayer_EmptyPotion.play()
				return
			
			heal_amount = greater_health_potion
			$AudioStreamPlayer_HealthPotion.play()
			Global.greater_health_potion_count -= 1
	
	Global.health = min(Global.max_health, Global.health + heal_amount)
	update_health_bar()
	HUDManager.update_health_potion_count(
		Global.equipped_health_potion_label, 
		Global.get_equipped_health_potion_count()
	)


## ############################################################################################## ##
##                                   APPLY FALL DAMAGE FUNCTION                                   ##
## ############################################################################################## ##
# Function to handle applying fall damage when player falls from a height higher than threshold.
func apply_fall_damage(fall_distance):
	var damage = (fall_distance - fall_damage_threshold) * damage_per_unit
	Global.health -= damage
	update_health_bar()
	print("Fall damage applied: ", damage)
	print(global_position.y)


## ############################################################################################## ##
##                                  RESET ALL VARIABLE TO DEFAULT                                 ##
## ############################################################################################## ##
# Resets variables to default, can be called from anywhere to reset player functionality.
func reset_variables_to_default():
	is_jumping = false
	is_double_jumping = false
	is_falling = false
	is_sliding = false
	is_dodging = false
	is_attacking = false
	is_shooting = false
	attack_step = 0
	attack_queued = false
	is_hit = false
	is_hit_reacting = false


## ############################################################################################## ##
##                                     FUNCTION TO PAUSE INPUT                                    ##
## ############################################################################################## ##
# Function to pause input, can be called from other scripts.
func pause_input():
	is_input_paused = true
	reset_variables_to_default()
	velocity.x = 0
	animated_sprite.play("idle")


## ############################################################################################## ##
##                                        SAVE GAME FUNCTION                                      ##
## ############################################################################################## ##
# Save function. Saving does not currently work. Needs to be fixed.
func save():
	# Compile all the data to save in a dictionary
	var save_dict = {
		pos = {
			x = get_position_delta().x,
			y = get_position_delta().y
		},
		health = Global.health
	}
	return save_dict
