extends Player

# Onready
onready var sprite = $Sprite
onready var aura = $AuraSprite

func _ready():
	# Sets width of special outline to 0
	sprite.get_material().set_shader_param("size", 0.0)

func _physics_process(delta):
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		stats.health += 1
		stats.emit_signal("health_changed", stats.health)
		# Sets the outline to a visible width
		sprite.get_material().set_shader_param("size", 0.5)
		special = true
		specialDuration.start(1)
	if state == ATTACK:
		aura.visible = true
	else:
		aura.visible = false
		
# Signal functions

func _on_SpecialDuration_timeout():
	special = false
	cooldown = true
	sprite.get_material().set_shader_param("size", 0.0) # Turn off outline
	specialCooldown.start(20)

func _on_SpecialCooldown_timeout():
	cooldown = false
