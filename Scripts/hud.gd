extends Control

#var health_bar
#var health_potion_counter
#var health_potion_icon
#var can_shoot_progress

@onready var weapon_texture = $Control/Sprite2D_Background/Sprite2D_Weapon
@onready var imbuement_sprite = $Control/Sprite2D_Imbuement
@onready var health_bar = $HealthBar
@onready var health_potion_counter = $HealthPotionCounter
@onready var health_potion_icon = $HealthPotionIcon
@onready var can_shoot_progress = $CanShootProgress


func _ready():
	#health_bar = $HealthBar
	#health_potion_counter = $HealthPotionCounter
	#health_potion_icon = $HealthPotionIcon
	#can_shoot_progress = $CanShootProgress

	update_health(Global.health)
	update_health_potion_count(Global.equipped_health_potion_label, Global.minor_health_potion_count)
	update_health_potion_icon(Global.equipped_health_potion_icon)
	update_weapon_type(Global.weapon_texture)
	set_imbuement_visible(Global.weapon_type)

func update_health(value):
	if health_bar:
		health_bar.value = value
	else:
		print("Healthbar instance is not available.")


func update_health_potion_count(equipped_health_potion, count):
	if health_potion_counter:
		health_potion_counter.text = str(equipped_health_potion) + " Health Potions: " + str(count)
	else:
		print("Health Potion counter label is not available.")


func update_health_potion_icon(equipped_health_potion_icon):
	if health_potion_icon:
		health_potion_icon.texture = equipped_health_potion_icon
	else:
		print("Health Potion icon is not available.")


func update_can_shoot_progress(max_time, current_time):
	if can_shoot_progress:
		can_shoot_progress.value = max_time - current_time
	else:
		print("Can Shoot Progress Bar is not available.")


func update_weapon_type(texture):
	if weapon_texture:
		weapon_texture.texture = texture
	else:
		print("Weapon texture is not available.")


func set_imbuement_visible(visible):
	if imbuement_sprite:
		imbuement_sprite.visible = visible
	else:
		print("Imbuement sprite is not available.")
