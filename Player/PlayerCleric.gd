extends Player

# Onready
onready var aura = $AuraSprite

func _physics_process(delta):
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		stats.health += 1
		stats.emit_signal("health_changed", stats.health)
		specialDuration.start(1)
	if state == ATTACK:
		aura.visible = true
	else:
		aura.visible = false
		
# Signal functions

func _on_SpecialDuration_timeout():
	special = false
	cooldown = true
	specialCooldown.start(20)

func _on_SpecialCooldown_timeout():
	cooldown = false
