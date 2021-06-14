extends Player

# Onready
onready var sprite = $Sprite
onready var specialAnimationPlayer = $SpecialAnimationPlayer
onready var aura = $AuraSprite

func _ready():
	# Sets outline to width of 0.0
	sprite.get_material().set_shader_param("size", 0.0)

func _physics_process(_delta):
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		stats.health += 1
		stats.emit_signal("health_changed", stats.health)
		# Sets the outline color to yellow
		sprite.get_material().set_shader_param("size", 0.5)
		special = true
		specialDuration.start()
	if state == ATTACK:
		aura.visible = true
	else:
		aura.visible = false
		
# Signal functions

func _on_SpecialDuration_timeout():
	special = false
	cooldown = true
	specialAnimationPlayer.play("SpecialEnd")
	specialCooldown.start()

func _on_SpecialCooldown_timeout():
	specialAnimationPlayer.play("CooldownEnd")
	cooldown = false
