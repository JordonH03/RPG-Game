extends Player

func _physics_process(delta):
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		hitbox.damage *= 2
		specialDuration.start()

func _on_SpecialDuration_timeout():
	special = false
	cooldown = true
	specialCooldown.start()

func _on_SpecialCooldown_timeout():
	cooldown = false
